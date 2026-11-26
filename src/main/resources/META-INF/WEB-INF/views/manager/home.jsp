<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Manager Dashboard - Hệ Thống ABC</title>
</head>
<body>
<div class="container-fluid">
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-3 bg-primary text-white">
                <div class="card-body d-flex justify-content-between align-items-center p-4">
                    <div>
                        <h6 class="text-uppercase opacity-75 mb-1">Tổng số Sản phẩm</h6>
                        <h2 class="fw-bold mb-0">${totalProducts}</h2>
                    </div>
                    <i class="bi bi-box-seam fs-1 opacity-75"></i>
                </div>
                <div class="card-footer bg-transparent border-top border-white border-opacity-25">
                    <a href="${pageContext.request.contextPath}/manager/products/searchpaginated" class="text-white text-decoration-none small fw-semibold">
                        Quản lý sản phẩm <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-3 bg-success text-white">
                <div class="card-body d-flex justify-content-between align-items-center p-4">
                    <div>
                        <h6 class="text-uppercase opacity-75 mb-1">Số Category hiện có</h6>
                        <h2 class="fw-bold mb-0">${totalCategories}</h2>
                    </div>
                    <i class="bi bi-tags-fill fs-1 opacity-75"></i>
                </div>
                <div class="card-footer bg-transparent border-top border-white border-opacity-25 small">
                    Category do Admin quản lý
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-info text-white py-3">
            <h5 class="mb-0 fw-bold"><i class="bi bi-briefcase me-2"></i>Bảng Quản Lý (Manager Dashboard)</h5>
        </div>
        <div class="card-body p-4">
            <div class="alert alert-info">
                <i class="bi bi-person-check-fill me-2"></i>Bạn đang đăng nhập với quyền <strong>Quản lý (Manager - Role 2)</strong>:
                thêm / sửa / xóa / tìm kiếm sản phẩm cho các Category.
            </div>
            <table class="table table-bordered table-striped mb-4">
                <tbody>
                    <tr><th style="width: 30%;">Username</th><td><strong>${sessionScope.account.username}</strong></td></tr>
                    <tr><th>Họ và tên</th><td>${sessionScope.account.fullname}</td></tr>
                    <tr><th>Email</th><td>${sessionScope.account.email}</td></tr>
                    <tr><th>Số điện thoại</th><td>${sessionScope.account.phone}</td></tr>
                </tbody>
            </table>
            <a href="${pageContext.request.contextPath}/manager/products/add" class="btn btn-success fw-bold me-2">
                <i class="bi bi-plus-circle me-1"></i>Thêm sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/manager/products/searchpaginated" class="btn btn-primary fw-bold">
                <i class="bi bi-box-seam me-1"></i>Danh sách sản phẩm
            </a>
        </div>
    </div>
</div>
</body>
</html>
