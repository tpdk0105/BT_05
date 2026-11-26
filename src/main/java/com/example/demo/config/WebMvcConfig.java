package com.example.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

	private final AdminInterceptor adminInterceptor;
	private final ManagerInterceptor managerInterceptor;

	public WebMvcConfig(AdminInterceptor adminInterceptor, ManagerInterceptor managerInterceptor) {
		this.adminInterceptor = adminInterceptor;
		this.managerInterceptor = managerInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(adminInterceptor).addPathPatterns("/admin", "/admin/**");
		registry.addInterceptor(managerInterceptor).addPathPatterns("/manager", "/manager/**");
	}
}
