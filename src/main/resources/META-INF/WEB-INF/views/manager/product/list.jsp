<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Sản Phẩm</title>
</head>
<body>
<div class="container-fluid">
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-primary text-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h5 class="mb-0 fw-bold"><i class="bi bi-box-seam me-2"></i>Quản Lý Sản Phẩm (Tìm kiếm &amp; Phân trang)</h5>
            <a href="<c:url value='/manager/products/add'/>" class="btn btn-light fw-bold text-primary btn-sm">
                <i class="bi bi-plus-circle-fill me-1"></i>Thêm sản phẩm
            </a>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            </c:if>

            <form action="<c:url value='/manager/products/searchpaginated'/>" method="get" class="row g-2 mb-4 align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="text" name="name" class="form-control" value="${name}" placeholder="Tên sản phẩm..." />
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="categoryId" class="form-select">
                        <option value="">-- Tất cả Category --</option>
                        <c:forEach items="${categories}" var="cate">
                            <option value="${cate.id}" ${categoryId == cate.id ? 'selected' : ''}>${cate.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="size" class="form-select" onchange="this.form.submit()">
                        <option ${productPage.size == 3 ? 'selected' : ''} value="3">3 / trang</option>
                        <option ${productPage.size == 5 ? 'selected' : ''} value="5">5 / trang</option>
                        <option ${productPage.size == 10 ? 'selected' : ''} value="10">10 / trang</option>
                        <option ${productPage.size == 20 ? 'selected' : ''} value="20">20 / trang</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary fw-semibold px-3">Search</button>
                    <a href="<c:url value='/manager/products/searchpaginated'/>" class="btn btn-outline-secondary">Xóa lọc</a>
                </div>
            </form>

            <c:if test="${!productPage.hasContent()}">
                <div class="alert alert-secondary text-center py-4 mb-0">Không tìm thấy sản phẩm nào.</div>
            </c:if>

            <c:if test="${productPage.hasContent()}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>STT</th><th>Ảnh</th><th>Tên sản phẩm</th><th>Category</th>
                                <th>Giá</th><th>SL</th><th>Status</th><th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${productPage.content}" var="p" varStatus="STT">
                                <tr>
                                    <td class="fw-bold">${productPage.number * productPage.size + STT.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.images && (fn:startsWith(p.images, 'http://') || fn:startsWith(p.images, 'https://'))}">
                                                <c:set var="imgUrl" value="${p.images}" />
                                            </c:when>
                                            <c:when test="${not empty p.images}">
                                                <c:url value="/image?fname=${p.images}" var="imgUrl" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="imgUrl" value="https://placehold.co/100x70?text=No+Image" />
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${imgUrl}" height="60" width="90" class="rounded img-thumbnail" style="object-fit: cover;"
                                             alt="${p.name}" onerror="this.src='https://placehold.co/100x70?text=No+Image'" />
                                    </td>
                                    <td class="text-start fw-semibold">${p.name}</td>
                                    <td><span class="badge bg-info text-dark">${p.category.name}</span></td>
                                    <td class="text-end"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫</td>
                                    <td>${p.quantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 1}"><span class="badge bg-success">Đang bán</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">Ẩn</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-nowrap">
                                        <a href="<c:url value='/manager/products/edit/${p.id}'/>" class="btn btn-sm btn-outline-warning me-1">
                                            <i class="bi bi-pencil-square"></i> Sửa</a>
                                        <form action="<c:url value='/manager/products/delete/${p.id}'/>" method="post" class="d-inline"
                                              onsubmit="return confirm('Xóa sản phẩm này?');">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i> Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 gap-2">
                    <div class="small text-muted">
                        Hiển thị <strong>${productPage.numberOfElements}</strong> / <strong>${productPage.totalElements}</strong> sản phẩm
                        (Trang <strong>${productPage.number + 1}</strong> / <strong>${productPage.totalPages}</strong>)
                    </div>
                    <c:if test="${productPage.totalPages > 1}">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${productPage.first ? 'disabled' : ''}">
                                <a class="page-link" href="<c:url value='/manager/products/searchpaginated'><c:param name='name' value='${name}'/><c:param name='categoryId' value='${categoryId}'/><c:param name='size' value='${productPage.size}'/><c:param name='page' value='${productPage.number}'/></c:url>">&lsaquo;</a>
                            </li>
                            <c:forEach items="${pageNumbers}" var="pn">
                                <li class="${pn == productPage.number + 1 ? 'page-item active' : 'page-item'}">
                                    <a class="page-link" href="<c:url value='/manager/products/searchpaginated'><c:param name='name' value='${name}'/><c:param name='categoryId' value='${categoryId}'/><c:param name='size' value='${productPage.size}'/><c:param name='page' value='${pn}'/></c:url>">${pn}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${productPage.last ? 'disabled' : ''}">
                                <a class="page-link" href="<c:url value='/manager/products/searchpaginated'><c:param name='name' value='${name}'/><c:param name='categoryId' value='${categoryId}'/><c:param name='size' value='${productPage.size}'/><c:param name='page' value='${productPage.number + 2}'/></c:url>">&rsaquo;</a>
                            </li>
                        </ul>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
