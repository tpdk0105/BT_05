package com.example.demo.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.sitemesh.webapp.DispatchMode;

public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {

	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
		builder.setDispatchMode(DispatchMode.INCLUDE)
				// Assigning default decorator if no path specific decorator found
				.addDecoratorPath("/*", "web.jsp")
				// Map decorators to specific path patterns
				.addDecoratorPath("/admin/*", "/admin.jsp")
				.addDecoratorPath("/manager/*", "/manager.jsp")
				.addDecoratorPath("/login*", "/login.jsp")
				.addDecoratorPath("/register*", "/login.jsp")
				// Exclude non-page paths from decoration
				.addExcludedPath("/alogin*").addExcludedPath("/alogin/*")
				.addExcludedPath("/api/**")
				.addExcludedPath("/image*")
				.addExcludedPath("/static/**")
				.addExcludedPath("/h2-console*").addExcludedPath("/h2-console/**")
				.addExcludedPath("/commons/**");
	}
}
