package com.example.demo.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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
import com.example.demo.service.ICategoryService;
import com.example.demo.util.Constant;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

	private final ICategoryService categoryService;

	public AdminCategoryController(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}

	@GetMapping({ "", "/", "/searchpaginated" })
	public String search(
			ModelMap model,
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "page") Optional<Integer> page,
			@RequestParam(name = "size") Optional<Integer> size) {

		int currentPage = Math.max(1, page.orElse(1));
		int pageSize = Math.max(1, size.orElse(5));

		Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("name").ascending());
		Page<Category> resultPage;

		if (StringUtils.hasText(name)) {
			String keyword = name.trim();
			resultPage = categoryService.findByNameContaining(keyword, pageable);
			model.addAttribute("name", keyword);
		} else {
			resultPage = categoryService.findAll(pageable);
		}

		int totalPages = resultPage.getTotalPages();
		if (totalPages > 0) {
			int window = 5;
			int start = Math.max(1, currentPage - 2);
			int end = Math.min(currentPage + 2, totalPages);
			if (totalPages > window) {
				if (end == totalPages) {
					start = Math.max(1, end - window + 1);
				} else if (start == 1) {
					end = Math.min(totalPages, start + window - 1);
				}
			}
			List<Integer> pageNumbers = IntStream.rangeClosed(start, end)
					.boxed()
					.collect(Collectors.toList());
			model.addAttribute("pageNumbers", pageNumbers);
		}

		model.addAttribute("categoryPage", resultPage);
		return "admin/category/list";
	}

	@GetMapping("/add")
	public String showAddForm(ModelMap model) {
		Category category = new Category();
		category.setStatus(1);
		model.addAttribute("category", category);
		model.addAttribute("isEdit", false);
		return "admin/category/addOrEdit";
	}

	@PostMapping("/insert")
	public String insertCategory(
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "images", required = false) String images,
			@RequestParam(name = "images1", required = false) MultipartFile imageFile,
			@RequestParam(name = "status", defaultValue = "1") int status,
			ModelMap model,
			RedirectAttributes redirectAttributes) {

		String trimmedName = name == null ? "" : name.trim();
		Category category = new Category();
		category.setName(trimmedName);
		category.setImages(images != null ? images.trim() : "");
		category.setStatus(status == 0 ? 0 : 1);

		if (trimmedName.length() < 2 || trimmedName.length() > 100) {
			model.addAttribute("error", "Tên thể loại phải từ 2 đến 100 ký tự!");
			model.addAttribute("category", category);
			model.addAttribute("isEdit", false);
			return "admin/category/addOrEdit";
		}

		if (categoryService.findByName(trimmedName).isPresent()) {
			model.addAttribute("error", "Tên thể loại \"" + trimmedName + "\" đã tồn tại!");
			model.addAttribute("category", category);
			model.addAttribute("isEdit", false);
			return "admin/category/addOrEdit";
		}

		try {
			String savedFile = saveUploadedImage(imageFile);
			if (savedFile != null) {
				category.setImages(savedFile);
			} else if (!StringUtils.hasText(category.getImages())) {
				category.setImages("avatar.png");
			}
		} catch (IOException e) {
			model.addAttribute("error", "Lỗi tải ảnh lên: " + e.getMessage());
			model.addAttribute("category", category);
			model.addAttribute("isEdit", false);
			return "admin/category/addOrEdit";
		}

		categoryService.save(category);
		redirectAttributes.addFlashAttribute("message", "Thêm mới thể loại \"" + category.getName() + "\" thành công!");
		return "redirect:/admin/categories/searchpaginated";
	}

	@GetMapping("/edit/{id}")
	public String showEditForm(@PathVariable("id") Integer id, ModelMap model, RedirectAttributes redirectAttributes) {
		Optional<Category> opt = categoryService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy thể loại có ID = " + id);
			return "redirect:/admin/categories/searchpaginated";
		}
		model.addAttribute("category", opt.get());
		model.addAttribute("isEdit", true);
		return "admin/category/addOrEdit";
	}

	@PostMapping("/update")
	public String updateCategory(
			@RequestParam("id") Integer id,
			@RequestParam(name = "name", required = false) String name,
			@RequestParam(name = "images", required = false) String images,
			@RequestParam(name = "images1", required = false) MultipartFile imageFile,
			@RequestParam(name = "status", defaultValue = "1") int status,
			ModelMap model,
			RedirectAttributes redirectAttributes) {

		Optional<Category> opt = categoryService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy thể loại cần cập nhật!");
			return "redirect:/admin/categories/searchpaginated";
		}

		Category category = opt.get();
		String oldImage = category.getImages();
		String trimmedName = name == null ? "" : name.trim();

		if (trimmedName.length() < 2 || trimmedName.length() > 100) {
			category.setName(trimmedName);
			model.addAttribute("error", "Tên thể loại phải từ 2 đến 100 ký tự!");
			model.addAttribute("category", category);
			model.addAttribute("isEdit", true);
			return "admin/category/addOrEdit";
		}

		Optional<Category> duplicate = categoryService.findByName(trimmedName);
		if (duplicate.isPresent() && !duplicate.get().getId().equals(id)) {
			category.setName(trimmedName);
			model.addAttribute("error", "Tên thể loại \"" + trimmedName + "\" đã tồn tại!");
			model.addAttribute("category", category);
			model.addAttribute("isEdit", true);
			return "admin/category/addOrEdit";
		}

		category.setName(trimmedName);
		category.setStatus(status == 0 ? 0 : 1);

		try {
			String savedFile = saveUploadedImage(imageFile);
			if (savedFile != null) {
				deleteOldLocalFile(oldImage);
				category.setImages(savedFile);
			} else if (StringUtils.hasText(images)) {
				category.setImages(images.trim());
			} else {
				category.setImages(oldImage);
			}
		} catch (IOException e) {
			model.addAttribute("error", "Lỗi tải ảnh lên: " + e.getMessage());
			model.addAttribute("category", category);
			model.addAttribute("isEdit", true);
			return "admin/category/addOrEdit";
		}

		categoryService.save(category);
		redirectAttributes.addFlashAttribute("message", "Cập nhật thể loại \"" + category.getName() + "\" thành công!");
		return "redirect:/admin/categories/searchpaginated";
	}

	@GetMapping("/delete/{id}")
	public String deleteCategoryGet(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
		return doDelete(id, redirectAttributes);
	}

	@PostMapping("/delete/{id}")
	public String deleteCategoryPost(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
		return doDelete(id, redirectAttributes);
	}

	private String doDelete(Integer id, RedirectAttributes redirectAttributes) {
		Optional<Category> opt = categoryService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy thể loại có ID = " + id);
		} else {
			try {
				categoryService.deleteById(id);
				redirectAttributes.addFlashAttribute("message",
						"Đã xóa thể loại \"" + opt.get().getName() + "\" thành công!");
			} catch (Exception e) {
				redirectAttributes.addFlashAttribute("error",
						"Không thể xóa thể loại này (có thể đang được liên kết dữ liệu khác)!");
			}
		}
		return "redirect:/admin/categories/searchpaginated";
	}

	private String saveUploadedImage(MultipartFile imageFile) throws IOException {
		if (imageFile == null || imageFile.isEmpty()) {
			return null;
		}
		File uploadDir = new File(Constant.DIR);
		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}
		String original = imageFile.getOriginalFilename();
		String ext = "png";
		if (original != null && original.contains(".")) {
			ext = original.substring(original.lastIndexOf('.') + 1);
		}
		String fileName = "cate_" + System.currentTimeMillis() + "." + ext;
		Path target = Paths.get(Constant.DIR, fileName);
		imageFile.transferTo(target);
		return fileName;
	}

	private void deleteOldLocalFile(String fileName) {
		if (StringUtils.hasText(fileName) && !fileName.startsWith("http") && !"avatar.png".equals(fileName)) {
			try {
				Files.deleteIfExists(Paths.get(Constant.DIR, fileName));
			} catch (IOException ignored) {
			}
		}
	}
}
