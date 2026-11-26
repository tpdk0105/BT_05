<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Chủ - Hệ Thống ABC</title>
</head>
<body>
<div class="container py-4">
    <div class="row justify-content-center mb-4">
        <div class="col-lg-10">
            <div class="card border-0 shadow rounded-3">
                <div class="card-header bg-primary text-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-house-heart-fill me-2"></i>Chào Mừng Đến Hệ Thống ABC (Spring Boot 4 + JSP/JSTL)</h5>
                    <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
                        <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-warning btn-sm fw-bold">
                            <i class="bi bi-speedometer2 me-1"></i>Vào Trang Quản Trị
                        </a>
                    </c:if>
                </div>
                <div class="card-body p-4">
                    <c:choose>
                        <c:when test="${sessionScope.account != null}">
                            <div class="alert alert-success mb-3">
                                <i class="bi bi-person-check-fill me-2"></i>
                                Xin chào <strong>${not empty sessionScope.account.fullname ? sessionScope.account.fullname : sessionScope.account.username}</strong>
                                (${sessionScope.account.email})!
                            </div>
                            <div class="row g-3 small text-secondary">
                                <div class="col-md-3"><strong>Username:</strong> ${sessionScope.account.username}</div>
                                <div class="col-md-3"><strong>SĐT:</strong> ${not empty sessionScope.account.phone ? sessionScope.account.phone : 'Chưa cập nhật'}</div>
                                <div class="col-md-3">
                                    <strong>Vai trò:</strong>
                                    <c:choose>
                                        <c:when test="${sessionScope.account.roleid == 1}"><span class="badge bg-danger">Admin</span></c:when>
                                        <c:when test="${sessionScope.account.roleid == 2}"><span class="badge bg-info text-dark">Manager</span></c:when>
                                        <c:otherwise><span class="badge bg-success">User</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-3"><strong>Ngày tạo:</strong> ${sessionScope.account.createdDate}</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle-fill me-2"></i>
                                Bạn chưa đăng nhập. Vui lòng đăng nhập hoặc đăng ký tài khoản mới để sử dụng đầy đủ chức năng.
                            </div>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary me-2">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary">
                                <i class="bi bi-person-plus me-1"></i>Đăng ký tài khoản
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Danh sách Thể loại -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <h4 class="fw-bold mb-3"><i class="bi bi-tags-fill text-primary me-2"></i>Danh Mục Thể Loại</h4>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-5">
                <c:forEach items="${categories}" var="cate">
                    <c:if test="${cate.status == 1}">
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm rounded-3 ${selectedCategoryId == cate.id ? 'border border-primary border-3' : ''}">
                                <c:choose>
                                    <c:when test="${not empty cate.images && (fn:startsWith(cate.images, 'http://') || fn:startsWith(cate.images, 'https://'))}">
                                        <c:set var="imgSrc" value="${cate.images}" />
                                    </c:when>
                                    <c:when test="${not empty cate.images}">
                                        <c:url value="/image?fname=${cate.images}" var="imgSrc" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="imgSrc" value="https://placehold.co/400x200?text=Category" />
                                    </c:otherwise>
                                </c:choose>
                                <img src="${imgSrc}" class="card-img-top" alt="${cate.name}" style="height: 160px; object-fit: cover;"
                                     onerror="this.src='https://placehold.co/400x200?text=No+Image'">
                                <div class="card-body">
                                    <h6 class="card-title fw-bold mb-1">
                                        <a href="${pageContext.request.contextPath}/home?categoryId=${cate.id}" class="text-decoration-none text-dark stretched-link">${cate.name}</a>
                                    </h6>
                                    <span class="badge bg-success">Hoạt động</span>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <!-- Sản phẩm -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold mb-0"><i class="bi bi-box-seam text-primary me-2"></i>
                    <c:choose>
                        <c:when test="${not empty selectedCategory}">Sản phẩm: ${selectedCategory.name}</c:when>
                        <c:otherwise>Tất cả sản phẩm</c:otherwise>
                    </c:choose>
                </h4>
                <c:if test="${not empty selectedCategory}">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">Xem tất cả</a>
                </c:if>
            </div>

            <c:if test="${!productPage.hasContent()}">
                <div class="alert alert-secondary text-center py-4">Chưa có sản phẩm nào.</div>
            </c:if>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                <c:forEach items="${productPage.content}" var="p">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm rounded-3">
                            <c:choose>
                                <c:when test="${not empty p.images && (fn:startsWith(p.images, 'http://') || fn:startsWith(p.images, 'https://'))}">
                                    <c:set var="pImg" value="${p.images}" />
                                </c:when>
                                <c:when test="${not empty p.images}">
                                    <c:url value="/image?fname=${p.images}" var="pImg" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="pImg" value="https://placehold.co/400x240?text=Product" />
                                </c:otherwise>
                            </c:choose>
                            <img src="${pImg}" class="card-img-top" alt="${p.name}" style="height: 170px; object-fit: cover;"
                                 onerror="this.src='https://placehold.co/400x240?text=No+Image'">
                            <div class="card-body">
                                <h6 class="card-title fw-bold mb-1">${p.name}</h6>
                                <div class="text-danger fw-bold"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫</div>
                                <div class="small text-muted text-truncate">${p.description}</div>
                            </div>
                            <div class="card-footer bg-white border-0 small">
                                <span class="badge bg-info text-dark">${p.category.name}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${productPage.totalPages > 1}">
                <ul class="pagination justify-content-center mt-4">
                    <c:forEach begin="1" end="${productPage.totalPages}" var="pn">
                        <li class="${pn == productPage.number + 1 ? 'page-item active' : 'page-item'}">
                            <a class="page-link" href="<c:url value='/home'><c:param name='categoryId' value='${selectedCategoryId}'/><c:param name='page' value='${pn}'/></c:url>">${pn}</a>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>