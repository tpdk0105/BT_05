package com.example.demo.controller;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.User;
import com.example.demo.service.IUserService;
import com.example.demo.util.Constant;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

	private final IUserService userService;

	public AuthController(IUserService userService) {
		this.userService = userService;
	}

	@GetMapping("/login")
	public String showLoginForm(HttpServletRequest request, HttpSession session) {
		if (session.getAttribute(Constant.SESSION_ACCOUNT) != null) {
			return "redirect:/waiting";
		}

		// Kiểm tra Cookie Remember Me
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (Constant.COOKIE_REMEMBER.equals(cookie.getName()) && StringUtils.hasText(cookie.getValue())) {
					Optional<User> opt = userService.findByUsername(cookie.getValue());
					if (opt.isPresent() && opt.get().getStatus() == 1) {
						User user = opt.get();
						session.setAttribute(Constant.SESSION_ACCOUNT, user);
						session.setAttribute(Constant.SESSION_USERNAME, user.getUsername());
						return "redirect:/waiting";
					}
				}
			}
		}
		return "web/login";
	}

	@PostMapping("/login")
	public String processLogin(
			@RequestParam(name = "username", required = false) String username,
			@RequestParam(name = "password", required = false) String password,
			@RequestParam(name = "remember", required = false) String remember,
			HttpSession session,
			HttpServletResponse response,
			Model model) {

		String u = username == null ? "" : username.trim();
		String p = password == null ? "" : password.trim();

		if (!StringUtils.hasText(u) || !StringUtils.hasText(p)) {
			model.addAttribute("alert", "Tài khoản hoặc mật khẩu không được để trống!");
			model.addAttribute("username", u);
			return "web/login";
		}

		User user = userService.login(u, p);
		if (user == null) {
			model.addAttribute("alert", "Tài khoản hoặc mật khẩu không đúng!");
			model.addAttribute("username", u);
			return "web/login";
		}

		if (user.getStatus() != 1) {
			model.addAttribute("alert", "Tài khoản của bạn đang bị khóa hoặc chưa kích hoạt!");
			model.addAttribute("username", u);
			return "web/login";
		}

		session.setAttribute(Constant.SESSION_ACCOUNT, user);
		session.setAttribute(Constant.SESSION_USERNAME, user.getUsername());

		if ("on".equalsIgnoreCase(remember) || "true".equalsIgnoreCase(remember)) {
			Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, user.getUsername());
			cookie.setMaxAge(30 * 60); // 30 phút
			cookie.setPath("/");
			response.addCookie(cookie);
		} else {
			clearRememberCookie(response);
		}

		return "redirect:/waiting";
	}

	@GetMapping("/register")
	public String showRegisterForm(HttpSession session) {
		if (session.getAttribute(Constant.SESSION_ACCOUNT) != null) {
			return "redirect:/waiting";
		}
		return "web/register";
	}

	@PostMapping("/register")
	public String processRegister(
			@RequestParam(name = "username", required = false) String username,
			@RequestParam(name = "fullname", required = false) String fullname,
			@RequestParam(name = "email", required = false) String email,
			@RequestParam(name = "phone", required = false) String phone,
			@RequestParam(name = "password", required = false) String password,
			@RequestParam(name = "confirmPassword", required = false) String confirmPassword,
			Model model,
			RedirectAttributes redirectAttributes) {

		String u = username == null ? "" : username.trim();
		String fn = fullname == null ? "" : fullname.trim();
		String em = email == null ? "" : email.trim();
		String ph = phone == null ? "" : phone.trim();
		String pw = password == null ? "" : password.trim();
		String cpw = confirmPassword == null ? "" : confirmPassword.trim();

		model.addAttribute("username", u);
		model.addAttribute("fullname", fn);
		model.addAttribute("email", em);
		model.addAttribute("phone", ph);

		if (!u.matches("^[a-zA-Z0-9_]{3,50}$")) {
			model.addAttribute("alert", "Tên tài khoản phải từ 3-50 ký tự (chữ, số hoặc dấu _) và không chứa khoảng trắng!");
			return "web/register";
		}

		if (!em.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
			model.addAttribute("alert", "Email không đúng định dạng!");
			return "web/register";
		}

		if (StringUtils.hasText(ph) && !ph.matches("^0\\d{9}$")) {
			model.addAttribute("alert", "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0!");
			return "web/register";
		}

		if (pw.length() < 6) {
			model.addAttribute("alert", "Mật khẩu phải có ít nhất 6 ký tự!");
			return "web/register";
		}

		if (StringUtils.hasText(cpw) && !pw.equals(cpw)) {
			model.addAttribute("alert", "Mật khẩu xác nhận không khớp!");
			return "web/register";
		}

		if (userService.existsByUsername(u)) {
			model.addAttribute("alert", "Tên tài khoản đã tồn tại!");
			return "web/register";
		}

		if (userService.existsByEmail(em)) {
			model.addAttribute("alert", "Email đã tồn tại trên hệ thống!");
			return "web/register";
		}

		userService.register(u, pw, em, fn, ph);
		redirectAttributes.addFlashAttribute("alertSuccess", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
		return "redirect:/login";
	}

	@GetMapping("/logout")
	public String logoutGet(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		return doLogout(request, response, redirectAttributes);
	}

	@PostMapping("/logout")
	public String logoutPost(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		return doLogout(request, response, redirectAttributes);
	}

	private String doLogout(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.removeAttribute(Constant.SESSION_ACCOUNT);
			session.removeAttribute(Constant.SESSION_USERNAME);
			session.invalidate();
		}
		clearRememberCookie(response);
		redirectAttributes.addFlashAttribute("alertSuccess", "Bạn đã đăng xuất thành công!");
		return "redirect:/login";
	}

	private void clearRememberCookie(HttpServletResponse response) {
		Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, "");
		cookie.setMaxAge(0);
		cookie.setPath("/");
		response.addCookie(cookie);
	}
}
