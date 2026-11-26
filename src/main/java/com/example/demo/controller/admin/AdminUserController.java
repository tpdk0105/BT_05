package com.example.demo.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
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

import com.example.demo.entity.User;
import com.example.demo.service.IUserService;
import com.example.demo.util.Constant;
import com.example.demo.util.PasswordUtil;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

	private final IUserService userService;

	public AdminUserController(IUserService userService) {
		this.userService = userService;
	}

	@GetMapping({ "", "/", "/searchpaginated" })
	public String search(
			ModelMap model,
			@RequestParam(name = "keyword", required = false) String keyword,
			@RequestParam(name = "page") Optional<Integer> page,
			@RequestParam(name = "size") Optional<Integer> size) {

		int currentPage = Math.max(1, page.orElse(1));
		int pageSize = Math.max(1, size.orElse(5));

		Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("id").descending());
		Page<User> resultPage;

		if (StringUtils.hasText(keyword)) {
			String trimmed = keyword.trim();
			resultPage = userService.search(trimmed, pageable);
			model.addAttribute("keyword", trimmed);
		} else {
			resultPage = userService.findAll(pageable);
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

		model.addAttribute("userPage", resultPage);
		return "admin/user/list";
	}

	@GetMapping("/add")
	public String showAddForm(ModelMap model) {
		User user = new User();
		user.setRoleid(3);
		user.setStatus(1);
		model.addAttribute("user", user);
		model.addAttribute("isEdit", false);
		return "admin/user/addOrEdit";
	}

	@PostMapping("/insert")
	public String insertUser(
			@RequestParam(name = "username", required = false) String username,
			@RequestParam(name = "fullname", required = false) String fullname,
			@RequestParam(name = "email", required = false) String email,
			@RequestParam(name = "phone", required = false) String phone,
			@RequestParam(name = "password", required = false) String password,
			@RequestParam(name = "roleid", defaultValue = "3") int roleid,
			@RequestParam(name = "status", defaultValue = "1") int status,
			@RequestParam(name = "avatar", required = false) String avatar,
			@RequestParam(name = "avatarFile", required = false) MultipartFile avatarFile,
			ModelMap model,
			RedirectAttributes redirectAttributes) {

		String u = username == null ? "" : username.trim();
		String fn = fullname == null ? "" : fullname.trim();
		String em = email == null ? "" : email.trim();
		String ph = phone == null ? "" : phone.trim();
		String pw = password == null ? "" : password.trim();

		User user = new User();
		user.setUsername(u);
		user.setFullname(fn);
		user.setEmail(em);
		user.setPhone(ph);
		user.setRoleid(roleid);
		user.setStatus(status == 0 ? 0 : 1);
		user.setAvatar(avatar != null ? avatar.trim() : null);

		if (!u.matches("^[a-zA-Z0-9_]{3,50}$")) {
			model.addAttribute("error", "Username phải từ 3-50 ký tự (chữ, số, dấu _)!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}
		if (!em.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
			model.addAttribute("error", "Email không hợp lệ!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}
		if (pw.length() < 6) {
			model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}
		if (userService.existsByUsername(u)) {
			model.addAttribute("error", "Username \"" + u + "\" đã tồn tại!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}
		if (userService.existsByEmail(em)) {
			model.addAttribute("error", "Email \"" + em + "\" đã tồn tại!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}

		try {
			String savedAvatar = saveUploadedAvatar(avatarFile);
			if (savedAvatar != null) {
				user.setAvatar(savedAvatar);
			}
		} catch (IOException e) {
			model.addAttribute("error", "Lỗi tải avatar: " + e.getMessage());
			model.addAttribute("user", user);
			model.addAttribute("isEdit", false);
			return "admin/user/addOrEdit";
		}

		user.setPassword(PasswordUtil.hashPassword(pw));
		user.setCreatedDate(new Date(System.currentTimeMillis()));
		userService.save(user);

		redirectAttributes.addFlashAttribute("message", "Thêm người dùng \"" + user.getUsername() + "\" thành công!");
		return "redirect:/admin/users/searchpaginated";
	}

	@GetMapping("/edit/{id}")
	public String showEditForm(@PathVariable("id") Integer id, ModelMap model, RedirectAttributes redirectAttributes) {
		Optional<User> opt = userService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng có ID = " + id);
			return "redirect:/admin/users/searchpaginated";
		}
		model.addAttribute("user", opt.get());
		model.addAttribute("isEdit", true);
		return "admin/user/addOrEdit";
	}

	@PostMapping("/update")
	public String updateUser(
			@RequestParam("id") Integer id,
			@RequestParam(name = "username", required = false) String username,
			@RequestParam(name = "fullname", required = false) String fullname,
			@RequestParam(name = "email", required = false) String email,
			@RequestParam(name = "phone", required = false) String phone,
			@RequestParam(name = "password", required = false) String password,
			@RequestParam(name = "roleid", defaultValue = "3") int roleid,
			@RequestParam(name = "status", defaultValue = "1") int status,
			@RequestParam(name = "avatar", required = false) String avatar,
			@RequestParam(name = "avatarFile", required = false) MultipartFile avatarFile,
			HttpSession session,
			ModelMap model,
			RedirectAttributes redirectAttributes) {

		Optional<User> opt = userService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng cần cập nhật!");
			return "redirect:/admin/users/searchpaginated";
		}

		User user = opt.get();
		String oldAvatar = user.getAvatar();

		String u = username == null ? "" : username.trim();
		String fn = fullname == null ? "" : fullname.trim();
		String em = email == null ? "" : email.trim();
		String ph = phone == null ? "" : phone.trim();
		String pw = password == null ? "" : password.trim();

		if (!u.matches("^[a-zA-Z0-9_]{3,50}$")) {
			model.addAttribute("error", "Username phải từ 3-50 ký tự (chữ, số, dấu _)!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", true);
			return "admin/user/addOrEdit";
		}
		if (!em.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
			model.addAttribute("error", "Email không hợp lệ!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", true);
			return "admin/user/addOrEdit";
		}

		Optional<User> dupUsername = userService.findByUsername(u);
		if (dupUsername.isPresent() && !dupUsername.get().getId().equals(id)) {
			model.addAttribute("error", "Username \"" + u + "\" đã thuộc tài khoản khác!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", true);
			return "admin/user/addOrEdit";
		}

		Optional<User> dupEmail = userService.findByEmail(em);
		if (dupEmail.isPresent() && !dupEmail.get().getId().equals(id)) {
			model.addAttribute("error", "Email \"" + em + "\" đã thuộc tài khoản khác!");
			model.addAttribute("user", user);
			model.addAttribute("isEdit", true);
			return "admin/user/addOrEdit";
		}

		if (StringUtils.hasText(pw)) {
			if (pw.length() < 6) {
				model.addAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
				model.addAttribute("user", user);
				model.addAttribute("isEdit", true);
				return "admin/user/addOrEdit";
			}
			user.setPassword(PasswordUtil.hashPassword(pw));
		}

		user.setUsername(u);
		user.setFullname(fn);
		user.setEmail(em);
		user.setPhone(ph);
		user.setRoleid(roleid);
		user.setStatus(status == 0 ? 0 : 1);

		try {
			String savedAvatar = saveUploadedAvatar(avatarFile);
			if (savedAvatar != null) {
				deleteOldLocalFile(oldAvatar);
				user.setAvatar(savedAvatar);
			} else if (StringUtils.hasText(avatar)) {
				user.setAvatar(avatar.trim());
			}
		} catch (IOException e) {
			model.addAttribute("error", "Lỗi tải avatar: " + e.getMessage());
			model.addAttribute("user", user);
			model.addAttribute("isEdit", true);
			return "admin/user/addOrEdit";
		}

		User updated = userService.save(user);
		User currentAcc = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
		if (currentAcc != null && currentAcc.getId().equals(updated.getId())) {
			session.setAttribute(Constant.SESSION_ACCOUNT, updated);
			session.setAttribute(Constant.SESSION_USERNAME, updated.getUsername());
		}

		redirectAttributes.addFlashAttribute("message", "Cập nhật người dùng \"" + updated.getUsername() + "\" thành công!");
		return "redirect:/admin/users/searchpaginated";
	}

	@GetMapping("/delete/{id}")
	public String deleteUserGet(@PathVariable("id") Integer id, HttpSession session,
			RedirectAttributes redirectAttributes) {
		return doDelete(id, session, redirectAttributes);
	}

	@PostMapping("/delete/{id}")
	public String deleteUserPost(@PathVariable("id") Integer id, HttpSession session,
			RedirectAttributes redirectAttributes) {
		return doDelete(id, session, redirectAttributes);
	}

	private String doDelete(Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
		User currentAcc = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
		if (currentAcc != null && currentAcc.getId().equals(id)) {
			redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản Admin đang đăng nhập!");
			return "redirect:/admin/users/searchpaginated";
		}

		Optional<User> opt = userService.findById(id);
		if (opt.isEmpty()) {
			redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng có ID = " + id);
		} else {
			try {
				userService.deleteById(id);
				redirectAttributes.addFlashAttribute("message",
						"Đã xóa người dùng \"" + opt.get().getUsername() + "\" thành công!");
			} catch (Exception e) {
				redirectAttributes.addFlashAttribute("error",
						"Không thể xóa người dùng này (có thể đang được liên kết dữ liệu khác)!");
			}
		}
		return "redirect:/admin/users/searchpaginated";
	}

	private String saveUploadedAvatar(MultipartFile avatarFile) throws IOException {
		if (avatarFile == null || avatarFile.isEmpty()) {
			return null;
		}
		File uploadDir = new File(Constant.DIR);
		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}
		String original = avatarFile.getOriginalFilename();
		String ext = "png";
		if (original != null && original.contains(".")) {
			ext = original.substring(original.lastIndexOf('.') + 1);
		}
		String fileName = "user_" + System.currentTimeMillis() + "." + ext;
		Path target = Paths.get(Constant.DIR, fileName);
		avatarFile.transferTo(target);
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
