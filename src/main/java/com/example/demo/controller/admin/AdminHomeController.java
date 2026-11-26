package com.example.demo.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.ICategoryService;
import com.example.demo.service.IUserService;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {

	private final ICategoryService categoryService;
	private final IUserService userService;

	public AdminHomeController(ICategoryService categoryService, IUserService userService) {
		this.categoryService = categoryService;
		this.userService = userService;
	}

	@GetMapping({ "", "/", "/home" })
	public String adminHome(Model model) {
		model.addAttribute("totalCategories", categoryService.count());
		model.addAttribute("totalUsers", userService.count());
		return "admin/home";
	}
}
