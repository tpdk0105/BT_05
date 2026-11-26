<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="bi bi-box-seam me-2"></i>Hệ Thống ABC
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#webNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="webNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i>Trang Chủ
                    </a>
                </li>
                <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/home">
                            <i class="bi bi-speedometer2 me-1"></i>Trang Quản Trị
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories/searchpaginated">
                            <i class="bi bi-tags me-1"></i>Category
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users/searchpaginated">
                            <i class="bi bi-people me-1"></i>User
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 2}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/manager/home">
                            <i class="bi bi-briefcase me-1"></i>Trang Quản Lý
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/manager/products/searchpaginated">
                            <i class="bi bi-box-seam me-1"></i>Sản phẩm
                        </a>
                    </li>
                </c:if>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.account == null}">
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-warning btn-sm fw-semibold" href="${pageContext.request.contextPath}/register">
                                <i class="bi bi-person-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-3 text-white d-flex align-items-center">
                            <c:choose>
                                <c:when test="${not empty sessionScope.account.avatar && (fn:startsWith(sessionScope.account.avatar, 'http://') || fn:startsWith(sessionScope.account.avatar, 'https://'))}">
                                    <img src="${sessionScope.account.avatar}" class="rounded-circle me-2 border border-light" width="30" height="30" style="object-fit: cover;" alt="avatar">
                                </c:when>
                                <c:when test="${not empty sessionScope.account.avatar}">
                                    <img src="${pageContext.request.contextPath}/image?fname=${sessionScope.account.avatar}" class="rounded-circle me-2 border border-light" width="30" height="30" style="object-fit: cover;" alt="avatar">
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-person-circle me-1 fs-5"></i>
                                </c:otherwise>
                            </c:choose>
                            <strong>${not empty sessionScope.account.fullname ? sessionScope.account.fullname : sessionScope.account.username}</strong>
                            <c:choose>
                                <c:when test="${sessionScope.account.roleid == 1}">
                                    <span class="badge bg-danger ms-2">Admin</span>
                                </c:when>
                                <c:when test="${sessionScope.account.roleid == 2}">
                                    <span class="badge bg-info text-dark ms-2">Manager</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success ms-2">User</span>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
