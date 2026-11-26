package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.web.filter.CharacterEncodingFilter;

import com.example.demo.config.CustomSiteMeshFilter;

@Configuration
@SpringBootApplication
public class Demo11Application {

	public static void main(String[] args) {
		SpringApplication.run(Demo11Application.class, args);
	}

	@Bean
	FilterRegistrationBean<CustomSiteMeshFilter> siteMeshFilter() {
		FilterRegistrationBean<CustomSiteMeshFilter> filterRegistrationBean = new FilterRegistrationBean<>();
		filterRegistrationBean.setFilter(new CustomSiteMeshFilter());
		filterRegistrationBean.addUrlPatterns("/*");
		return filterRegistrationBean;
	}

	@Bean
	@Order(Ordered.HIGHEST_PRECEDENCE)
	CharacterEncodingFilter characterEncodingFilter() {
		CharacterEncodingFilter filter = new CharacterEncodingFilter();
		filter.setEncoding("UTF-8");
		filter.setForceEncoding(true);
		return filter;
	}
}
