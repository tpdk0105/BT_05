package com.example.demo.controller.manager;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Category;
import com.example.demo.entity.Product;
import com.example.demo.service.ICategoryService;
import com.example.demo.service.IProductService;
import com.example.demo.util.Constant;

/** Khu vực của Manager (roleid = 2): quản lý sản phẩm thuộc các Category. */
@Controller
@RequestMapping("/manager")
public class ManagerProductController {

	private final IProductService productService;
	private final ICategoryService categoryService;

	public ManagerProductController(IProductService productService, ICategoryService categoryService) {
		this.productService = productService;
		this.categoryService = categoryService;
	}

	@GetMapping({ "", "/", "/home" })
	public String home(ModelMap model) {
		model.addAttribute("totalProducts", productService.count());
		model.addAttribute("totalCategories", categoryService.count());
		return "manager/home";
	}

	@GetMapping({ "/products", "/products/searchpaginated" })
	public String search(ModelMap model,
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "categoryId", required = false) Integer categoryId,
			@RequestParam(name = "page") Optional<Integer> page,
			@RequestParam(name = "size") Optional<Integer> size) {

		int currentPage = Math.max(1, page.orElse(1));
		int pageSize = Math.max(1, size.orElse(5));
		Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("id").descending());

		String keyword = StringUtils.hasText(name) ? name.trim() : null;
		Page<Product> result = productService.search(keyword, categoryId, pageable);

		int totalPages = result.getTotalPages();
		if (totalPages > 0) {
			int start = Math.max(1, currentPage - 2);
			int end = Math.min(currentPage + 2, totalPages);
			if (totalPages > 5) {
				if (end == totalPages) {
					start = Math.max(1, end - 4);
				} else if (start == 1) {
					end = Math.min(totalPages, 5);
				}
			}
			List<Integer> nums = IntStream.rangeClosed(start, end).boxed().collect(Collectors.toList());
			model.addAttribute("pageNumbers", nums);
		}

		model.addAttribute("productPage", result);
		model.addAttribute("name", keyword);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("categories", categoryService.findAll());
		return "manager/product/list";
	}

	@GetMapping("/products/add")
	public String showAdd(ModelMap model, @RequestParam(name = "categoryId", required = false) Integer categoryId) {
		Product p = new Product();
		if (categoryId != null) {
			categoryService.findById(categoryId).ifPresent(p::setCategory);
		}
		fillForm(model, p, false);
		return "manager/product/addOrEdit";
	}

	@PostMapping("/products/insert")
	public String insert(
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "categoryId", required = false) Integer categoryId,
			@RequestParam(name = "price", required = false) String price,
			@RequestParam(name = "quantity", defaultValue = "0") int quantity,
			@RequestParam(name = "description", required = false) String description,
			@RequestParam(name = "images", required = false) String images,
			@RequestParam(name = "images1", required = false) MultipartFile imageFile,
			@RequestParam(name = "status", defaultValue = "1") int status,
			ModelMap model, RedirectAttributes ra) {

		Product p = new Product();
		String error = bind(p, name, categoryId, price, quantity, description, images, status);
		if (error == null) {
			try {
				String saved = saveImage(imageFile);
				if (saved != null) {
					p.setImages(saved);
				}
			} catch (IOException e) {
				error = "Lỗi tải ảnh lên: " + e.getMessage();
			}
		}
		if (error != null) {
			model.addAttribute("error", error);
			fillForm(model, p, false);
			return "manager/product/addOrEdit";
		}
		p.setCreatedDate(new Timestamp(System.currentTimeMillis()));
		productService.save(p);
		ra.addFlashAttribute("message", "Thêm sản phẩm \"" + p.getName() + "\" thành công!");
		return "redirect:/manager/products/searchpaginated";
	}

	@GetMapping("/products/edit/{id}")
	public String showEdit(@PathVariable("id") Integer id, ModelMap model, RedirectAttributes ra) {
		Optional<Product> opt = productService.findById(id);
		if (opt.isEmpty()) {
			ra.addFlashAttribute("error", "Không tìm thấy sản phẩm có ID = " + id);
			return "redirect:/manager/products/searchpaginated";
		}
		fillForm(model, opt.get(), true);
		return "manager/product/addOrEdit";
	}

	@PostMapping("/products/update")
	public String update(
			@RequestParam("id") Integer id,
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "categoryId", required = false) Integer categoryId,
			@RequestParam(name = "price", required = false) String price,
			@RequestParam(name = "quantity", defaultValue = "0") int quantity,
			@RequestParam(name = "description", required = false) String description,
			@RequestParam(name = "images", required = false) String images,
			@RequestParam(name = "images1", required = false) MultipartFile imageFile,
			@RequestParam(name = "status", defaultValue = "1") int status,
			ModelMap model, RedirectAttributes ra) {

		Optional<Product> opt = productService.findById(id);
		if (opt.isEmpty()) {
			ra.addFlashAttribute("error", "Không tìm thấy sản phẩm cần cập nhật!");
			return "redirect:/manager/products/searchpaginated";
		}
		Product p = opt.get();
		String oldImage = p.getImages();
		String error = bind(p, name, categoryId, price, quantity, description, images, status);
		if (error == null) {
			try {
				String saved = saveImage(imageFile);
				if (saved != null) {
					deleteLocal(oldImage);
					p.setImages(saved);
				} else if (!StringUtils.hasText(images)) {
					p.setImages(oldImage);
				}
			} catch (IOException e) {
				error = "Lỗi tải ảnh lên: " + e.getMessage();
			}
		}
		if (error != null) {
			model.addAttribute("error", error);
			fillForm(model, p, true);
			return "manager/product/addOrEdit";
		}
		productService.save(p);
		ra.addFlashAttribute("message", "Cập nhật sản phẩm \"" + p.getName() + "\" thành công!");
		return "redirect:/manager/products/searchpaginated";
	}

	@GetMapping("/products/delete/{id}")
	public String deleteGet(@PathVariable("id") Integer id, RedirectAttributes ra) {
		return doDelete(id, ra);
	}

	@PostMapping("/products/delete/{id}")
	public String deletePost(@PathVariable("id") Integer id, RedirectAttributes ra) {
		return doDelete(id, ra);
	}

	private String doDelete(Integer id, RedirectAttributes ra) {
		Optional<Product> opt = productService.findById(id);
		if (opt.isEmpty()) {
			ra.addFlashAttribute("error", "Không tìm thấy sản phẩm có ID = " + id);
		} else {
			productService.deleteById(id);
			deleteLocal(opt.get().getImages());
			ra.addFlashAttribute("message", "Đã xóa sản phẩm \"" + opt.get().getName() + "\" thành công!");
		}
		return "redirect:/manager/products/searchpaginated";
	}

	private void fillForm(ModelMap model, Product p, boolean isEdit) {
		model.addAttribute("product", p);
		model.addAttribute("isEdit", isEdit);
		model.addAttribute("categories", categoryService.findAll());
	}

	/** Gán dữ liệu form vào Product, trả về thông báo lỗi nếu không hợp lệ (null nếu OK). */
	private String bind(Product p, String name, Integer categoryId, String price, int quantity,
			String description, String images, int status) {
		String n = name == null ? "" : name.trim();
		p.setName(n);
		p.setDescription(description);
		p.setQuantity(Math.max(0, quantity));
		p.setStatus(status == 0 ? 0 : 1);
		if (StringUtils.hasText(images)) {
			p.setImages(images.trim());
		}
		Optional<Category> cate = categoryId == null ? Optional.empty() : categoryService.findById(categoryId);
		cate.ifPresent(p::setCategory);

		if (n.length() < 2 || n.length() > 200) {
			return "Tên sản phẩm phải từ 2 đến 200 ký tự!";
		}
		if (cate.isEmpty()) {
			return "Vui lòng chọn Category cho sản phẩm!";
		}
		try {
			BigDecimal value = new BigDecimal(price == null ? "" : price.trim().replace(",", ""));
			if (value.signum() < 0) {
				return "Giá sản phẩm không được âm!";
			}
			p.setPrice(value);
		} catch (NumberFormatException e) {
			return "Giá sản phẩm không hợp lệ!";
		}
		return null;
	}

	private String saveImage(MultipartFile file) throws IOException {
		if (file == null || file.isEmpty()) {
			return null;
		}
		File dir = new File(Constant.DIR);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		String original = file.getOriginalFilename();
		String ext = (original != null && original.contains(".")) ? original.substring(original.lastIndexOf('.') + 1)
				: "png";
		String fileName = "prod_" + System.currentTimeMillis() + "." + ext;
		file.transferTo(Paths.get(Constant.DIR, fileName));
		return fileName;
	}

	private void deleteLocal(String fileName) {
		if (StringUtils.hasText(fileName) && !fileName.startsWith("http")) {
			try {
				Files.deleteIfExists(Paths.get(Constant.DIR, fileName));
			} catch (IOException ignored) {
			}
		}
	}
}
