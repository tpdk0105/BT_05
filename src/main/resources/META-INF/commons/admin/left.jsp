<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="list-group shadow-sm rounded-3 overflow-hidden">
    <div class="list-group-item bg-primary text-white fw-bold">
        <i class="bi bi-menu-button-wide me-2"></i>Menu Quản Trị
    </div>
    <a href="${pageContext.request.contextPath}/admin/home" class="list-group-item list-group-item-action">
        <i class="bi bi-speedometer2 me-2 text-danger"></i>Admin Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="list-group-item list-group-item-action">
        <i class="bi bi-tags-fill me-2 text-primary"></i>Quản lý Category
    </a>
    <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="list-group-item list-group-item-action">
        <i class="bi bi-people-fill me-2 text-success"></i>Quản lý User
    </a>
    <a href="${pageContext.request.contextPath}/home" class="list-group-item list-group-item-action">
        <i class="bi bi-globe me-2 text-info"></i>Về trang chủ
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action text-danger">
        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
    </a>
</div>
