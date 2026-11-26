package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.entity.Product;
import com.example.demo.entity.User;
import com.example.demo.service.ICategoryService;
import com.example.demo.service.IProductService;
import com.example.demo.util.Constant;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {

	private final ICategoryService categoryService;
	private final IProductService productService;

	public HomeController(ICategoryService categoryService, IProductService productService) {
		this.categoryService = categoryService;
		this.productService = productService;
	}

	@GetMapping({ "/", "/home" })
	public String home(Model model,
			@RequestParam(name = "categoryId", required = false) Integer categoryId,
			@RequestParam(name = "page", defaultValue = "1") int page) {
		int current = Math.max(1, page);
		Page<Product> products = productService.findActive(categoryId,
				PageRequest.of(current - 1, 8, Sort.by("id").descending()));
		model.addAttribute("categories", categoryService.findAll());
		model.addAttribute("productPage", products);
		model.addAttribute("selectedCategoryId", categoryId);
		if (categoryId != null) {
			categoryService.findById(categoryId).ifPresent(c -> model.addAttribute("selectedCategory", c));
		}
		return "web/home";
	}

	@GetMapping("/waiting")
	public String waiting(HttpSession session) {
		User account = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
		if (account == null) {
			return "redirect:/login";
		}
		if (account.getRoleid() == 1) {
			return "redirect:/admin/home";
		}
		if (account.getRoleid() == 2) {
			return "redirect:/manager/home";
		}
		return "redirect:/home";
	}

	@GetMapping("/image")
	public void downloadImage(@RequestParam("fname") String fileName, HttpServletResponse response) throws IOException {
		if (fileName == null || fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		File file = new File(Constant.DIR, fileName);
		if (!file.exists() || !file.isFile()) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		String contentType = Files.probeContentType(file.toPath());
		response.setContentType(contentType != null ? contentType : "application/octet-stream");
		Files.copy(file.toPath(), response.getOutputStream());
	}
}
