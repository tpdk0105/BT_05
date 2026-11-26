<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Thể Loại (Categories)</title>
</head>
<body>
<div class="container-fluid">
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-primary text-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h5 class="mb-0 fw-bold"><i class="bi bi-tags-fill me-2"></i>Quản Lý Thể Loại (Category - Tìm kiếm &amp; Phân trang)</h5>
            <a href="<c:url value='/admin/categories/add'/>" class="btn btn-light fw-bold text-primary btn-sm">
                <i class="bi bi-plus-circle-fill me-1"></i>Add Category
            </a>
        </div>

        <div class="card-body p-4">
            <!-- Thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Thanh tìm kiếm & chọn số dòng / trang -->
            <div class="row g-3 mb-4 align-items-center">
                <div class="col-md-7">
                    <form action="<c:url value='/admin/categories/searchpaginated'/>" method="get" class="d-flex gap-2">
                        <input type="hidden" name="size" value="${categoryPage.size}" />
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="name" id="name" class="form-control"
                                   value="${name}" placeholder="Nhập tên thể loại để tìm kiếm..." />
                        </div>
                        <button type="submit" class="btn btn-primary fw-semibold px-3">Search</button>
                        <c:if test="${not empty name}">
                            <a href="<c:url value='/admin/categories/searchpaginated?size=${categoryPage.size}'/>" class="btn btn-outline-secondary">Xóa lọc</a>
                        </c:if>
                    </form>
                </div>
                <div class="col-md-5 d-flex justify-content-md-end align-items-center gap-2">
                    <form action="<c:url value='/admin/categories/searchpaginated'/>" method="get" class="d-flex align-items-center gap-2">
                        <c:if test="${not empty name}">
                            <input type="hidden" name="name" value="${name}" />
                        </c:if>
                        <label for="size" class="form-label mb-0 fw-semibold small text-nowrap">Page size:</label>
                        <select name="size" id="size" class="form-select form-select-sm w-auto" onchange="this.form.submit()">
                            <option ${categoryPage.size == 3 ? 'selected' : ''} value="3">3</option>
                            <option ${categoryPage.size == 5 ? 'selected' : ''} value="5">5</option>
                            <option ${categoryPage.size == 10 ? 'selected' : ''} value="10">10</option>
                            <option ${categoryPage.size == 15 ? 'selected' : ''} value="15">15</option>
                            <option ${categoryPage.size == 20 ? 'selected' : ''} value="20">20</option>
                        </select>
                    </form>
                </div>
            </div>

            <!-- Bảng dữ liệu -->
            <c:if test="${!categoryPage.hasContent()}">
                <div class="alert alert-secondary text-center py-4 mb-0">
                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                    Không tìm thấy Category nào.
                </div>
            </c:if>

            <c:if test="${categoryPage.hasContent()}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 6%;">STT</th>
                                <th style="width: 8%;">ID</th>
                                <th style="width: 22%;">Images</th>
                                <th style="width: 32%;">Category name</th>
                                <th style="width: 14%;">Status</th>
                                <th style="width: 18%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${categoryPage.content}" var="cate" varStatus="STT">
                                <tr>
                                    <td class="fw-bold">${categoryPage.number * categoryPage.size + STT.index + 1}</td>
                                    <td><span class="badge bg-light text-dark border">#${cate.id}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cate.images && (fn:startsWith(cate.images, 'http://') || fn:startsWith(cate.images, 'https://'))}">
                                                <c:set var="imgUrl" value="${cate.images}" />
                                            </c:when>
                                            <c:when test="${not empty cate.images}">
                                                <c:url value="/image?fname=${cate.images}" var="imgUrl" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="imgUrl" value="https://placehold.co/120x80?text=No+Image" />
                                            </c:otherwise>
                                        </c:choose>
                                        <img height="70" width="100" src="${imgUrl}" class="rounded shadow-sm img-thumbnail"
                                             style="object-fit: cover;" alt="${cate.name}"
                                             onerror="this.src='https://placehold.co/120x80?text=No+Image'" />
                                    </td>
                                    <td class="fw-semibold text-start ps-3">${cate.name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cate.status == 1}">
                                                <span class="badge bg-success px-3 py-2"><i class="bi bi-check-circle me-1"></i>Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary px-3 py-2"><i class="bi bi-lock-fill me-1"></i>Khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="<c:url value='/admin/categories/edit/${cate.id}'/>" class="btn btn-sm btn-outline-warning me-1">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <form action="<c:url value='/admin/categories/delete/${cate.id}'/>" method="post" class="d-inline"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa thể loại \'${fn:escapeXml(cate.name)}\'?');">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i> Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang -->
                <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 gap-2">
                    <div class="small text-muted">
                        Hiển thị <strong>${categoryPage.numberOfElements}</strong> / <strong>${categoryPage.totalElements}</strong> kết quả
                        (Trang <strong>${categoryPage.number + 1}</strong> / <strong>${categoryPage.totalPages}</strong>)
                    </div>
                    <c:if test="${categoryPage.totalPages > 1}">
                        <nav aria-label="Category pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${categoryPage.first ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/categories/searchpaginated'><c:param name='name' value='${name}'/><c:param name='size' value='${categoryPage.size}'/><c:param name='page' value='1'/></c:url>">&laquo;</a>
                                </li>
                                <li class="page-item ${categoryPage.first ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/categories/searchpaginated'><c:param name='name' value='${name}'/><c:param name='size' value='${categoryPage.size}'/><c:param name='page' value='${categoryPage.number}'/></c:url>">&lsaquo;</a>
                                </li>
                                <c:forEach items="${pageNumbers}" var="pageNumber">
                                    <li class="${pageNumber == categoryPage.number + 1 ? 'page-item active' : 'page-item'}">
                                        <a class="page-link" href="<c:url value='/admin/categories/searchpaginated'><c:param name='name' value='${name}'/><c:param name='size' value='${categoryPage.size}'/><c:param name='page' value='${pageNumber}'/></c:url>">${pageNumber}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${categoryPage.last ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/categories/searchpaginated'><c:param name='name' value='${name}'/><c:param name='size' value='${categoryPage.size}'/><c:param name='page' value='${categoryPage.number + 2}'/></c:url>">&rsaquo;</a>
                                </li>
                                <li class="page-item ${categoryPage.last ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/categories/searchpaginated'><c:param name='name' value='${name}'/><c:param name='size' value='${categoryPage.size}'/><c:param name='page' value='${categoryPage.totalPages}'/></c:url>">&raquo;</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </c:if>
        </div>

        <div class="card-footer bg-white py-3">
            <a href="<c:url value='/admin/home'/>" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>Quay lại Admin Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>
