<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tạo Tài Khoản Mới</title>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow rounded-3">
                <div class="card-header bg-primary text-white text-center py-3">
                    <i class="bi bi-person-plus-fill fs-1"></i>
                    <h4 class="mt-2 mb-0 fw-bold">Tạo Tài Khoản Mới</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${alert}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="username">Tài khoản <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text"
                                       class="form-control"
                                       id="username"
                                       name="username"
                                       placeholder="Nhập tên tài khoản (3-50 ký tự)"
                                       value="${username}"
                                       required />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="fullname">Họ và tên</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                <input type="text"
                                       class="form-control"
                                       id="fullname"
                                       name="fullname"
                                       placeholder="Nhập họ tên"
                                       value="${fullname}" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="email">Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email"
                                       class="form-control"
                                       id="email"
                                       name="email"
                                       placeholder="example@gmail.com"
                                       value="${email}"
                                       required />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="phone">Số điện thoại</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel"
                                       class="form-control"
                                       id="phone"
                                       name="phone"
                                       placeholder="VD: 0901234567"
                                       value="${phone}" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="password">Mật khẩu <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       placeholder="Ít nhất 6 ký tự"
                                       minlength="6"
                                       required />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold" for="confirmPassword">Nhập lại mật khẩu <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                <input type="password"
                                       class="form-control"
                                       id="confirmPassword"
                                       name="confirmPassword"
                                       placeholder="Nhập lại mật khẩu"
                                       minlength="6"
                                       required />
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold">
                                <i class="bi bi-check2-circle me-2"></i>Tạo tài khoản
                            </button>
                        </div>
                    </form>

                    <hr class="my-4" />

                    <div class="text-center">
                        <span class="text-muted">Đã có tài khoản? </span>
                        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold">Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
