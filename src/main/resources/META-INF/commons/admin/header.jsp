<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-warning" href="${pageContext.request.contextPath}/admin/home">
            <i class="bi bi-shield-lock-fill me-2"></i>Hệ Thống ABC - Quản Trị (Spring Boot 4)
        </a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3 small">
                <i class="bi bi-person-circle me-1"></i>
                <strong>${not empty sessionScope.account.fullname ? sessionScope.account.fullname : sessionScope.account.username}</strong>
                <span class="badge bg-danger ms-1">Admin</span>
            </span>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm me-2">
                <i class="bi bi-house me-1"></i>Trang Web
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
            </a>
        </div>
    </div>
</nav>
