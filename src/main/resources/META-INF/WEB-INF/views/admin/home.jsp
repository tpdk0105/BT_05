<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Admin Dashboard - Hệ Thống ABC</title>
</head>
<body>
<div class="container-fluid">
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-3 bg-primary text-white">
                <div class="card-body d-flex justify-content-between align-items-center p-4">
                    <div>
                        <h6 class="text-uppercase opacity-75 mb-1">Tổng số Category</h6>
                        <h2 class="fw-bold mb-0">${totalCategories}</h2>
                    </div>
                    <i class="bi bi-tags-fill fs-1 opacity-75"></i>
                </div>
                <div class="card-footer bg-transparent border-top border-white border-opacity-25">
                    <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="text-white text-decoration-none small fw-semibold">
                        Quản lý Category <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-3 bg-success text-white">
                <div class="card-body d-flex justify-content-between align-items-center p-4">
                    <div>
                        <h6 class="text-uppercase opacity-75 mb-1">Tổng số User</h6>
                        <h2 class="fw-bold mb-0">${totalUsers}</h2>
                    </div>
                    <i class="bi bi-people-fill fs-1 opacity-75"></i>
                </div>
                <div class="card-footer bg-transparent border-top border-white border-opacity-25">
                    <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="text-white text-decoration-none small fw-semibold">
                        Quản lý User <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-danger text-white py-3">
            <h5 class="mb-0 fw-bold"><i class="bi bi-speedometer2 me-2"></i>Thông Tin Quản Trị Viên</h5>
        </div>
        <div class="card-body p-4">
            <div class="alert alert-warning">
                <i class="bi bi-shield-lock-fill me-2"></i>Bạn đang đăng nhập với quyền <strong>Quản trị viên (Admin - Role 1)</strong>.
            </div>

            <table class="table table-bordered table-striped mb-4">
                <tbody>
                    <tr>
                        <th style="width: 30%;">ID</th>
                        <td>${sessionScope.account.id}</td>
                    </tr>
                    <tr>
                        <th>Tên đăng nhập (Username)</th>
                        <td><strong>${sessionScope.account.username}</strong></td>
                    </tr>
                    <tr>
                        <th>Họ và tên</th>
                        <td>${sessionScope.account.fullname}</td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td>${sessionScope.account.email}</td>
                    </tr>
                    <tr>
                        <th>Số điện thoại</th>
                        <td>${sessionScope.account.phone}</td>
                    </tr>
                    <tr>
                        <th>Vai trò</th>
                        <td><span class="badge bg-danger">1 (Admin)</span></td>
                    </tr>
                    <tr>
                        <th>Ngày tạo</th>
                        <td>${sessionScope.account.createdDate}</td>
                    </tr>
                </tbody>
            </table>

            <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center">
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-primary fw-bold">
                        <i class="bi bi-tags-fill me-1"></i>CRUD Category (Tìm kiếm &amp; Phân trang)
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="btn btn-success fw-bold">
                        <i class="bi bi-people-fill me-1"></i>CRUD User (Tìm kiếm &amp; Phân trang)
                    </a>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
