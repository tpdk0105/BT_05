<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng Nhập Vào Hệ Thống</title>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card border-0 shadow rounded-3">
                <div class="card-header bg-primary text-white text-center py-3">
                    <i class="bi bi-shield-lock fs-1"></i>
                    <h4 class="mt-2 mb-0 fw-bold">Đăng Nhập Hệ Thống</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${alert}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty alertSuccess}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${alertSuccess}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="username">Tài khoản</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                                <input type="text"
                                       class="form-control"
                                       id="username"
                                       name="username"
                                       placeholder="Nhập tên đăng nhập"
                                       value="${not empty username ? username : cookie.username.value}"
                                       required />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="password">Mật khẩu</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       placeholder="Nhập mật khẩu"
                                       required />
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="form-check">
                                <input class="form-check-input"
                                       type="checkbox"
                                       id="remember"
                                       name="remember"
                                       ${cookie.username != null ? 'checked' : ''} />
                                <label class="form-check-label" for="remember">Nhớ tôi</label>
                            </div>
                            <a href="${pageContext.request.contextPath}/home" class="text-decoration-none small text-secondary">
                                <i class="bi bi-house me-1"></i>Trang chủ
                            </a>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
                            </button>
                        </div>
                    </form>

                    <hr class="my-4" />

                    <div class="text-center">
                        <span class="text-muted">Chưa có tài khoản? </span>
                        <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold">Đăng ký ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
