package com.example.demo.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.entity.User;
import com.example.demo.util.Constant;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AdminInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute(Constant.SESSION_ACCOUNT) == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return false;
		}
		User account = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
		if (account.getRoleid() != 1) {
			response.sendRedirect(request.getContextPath() + "/waiting");
			return false;
		}
		return true;
	}
}
