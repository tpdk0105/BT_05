<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="list-group shadow-sm rounded-3 overflow-hidden">
    <div class="list-group-item bg-info text-white fw-bold">
        <i class="bi bi-menu-button-wide me-2"></i>Menu Manager
    </div>
    <a href="${pageContext.request.contextPath}/manager/home" class="list-group-item list-group-item-action">
        <i class="bi bi-speedometer2 me-2 text-info"></i>Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/manager/products/searchpaginated" class="list-group-item list-group-item-action">
        <i class="bi bi-box-seam me-2 text-primary"></i>Quản lý Sản phẩm
    </a>
    <a href="${pageContext.request.contextPath}/manager/products/add" class="list-group-item list-group-item-action">
        <i class="bi bi-plus-circle me-2 text-success"></i>Thêm Sản phẩm
    </a>
    <a href="${pageContext.request.contextPath}/home" class="list-group-item list-group-item-action">
        <i class="bi bi-globe me-2 text-secondary"></i>Về trang chủ
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action text-danger">
        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
    </a>
</div>
