<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Người Dùng (Users)</title>
</head>
<body>
<div class="container-fluid">
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-success text-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h5 class="mb-0 fw-bold"><i class="bi bi-people-fill me-2"></i>Quản Lý Người Dùng (User - Tìm kiếm &amp; Phân trang)</h5>
            <a href="<c:url value='/admin/users/add'/>" class="btn btn-light fw-bold text-success btn-sm">
                <i class="bi bi-person-plus-fill me-1"></i>Add User
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
                    <form action="<c:url value='/admin/users/searchpaginated'/>" method="get" class="d-flex gap-2">
                        <input type="hidden" name="size" value="${userPage.size}" />
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="keyword" id="keyword" class="form-control"
                                   value="${keyword}" placeholder="Tìm theo username, họ tên hoặc email..." />
                        </div>
                        <button type="submit" class="btn btn-success fw-semibold px-3">Search</button>
                        <c:if test="${not empty keyword}">
                            <a href="<c:url value='/admin/users/searchpaginated?size=${userPage.size}'/>" class="btn btn-outline-secondary">Xóa lọc</a>
                        </c:if>
                    </form>
                </div>
                <div class="col-md-5 d-flex justify-content-md-end align-items-center gap-2">
                    <form action="<c:url value='/admin/users/searchpaginated'/>" method="get" class="d-flex align-items-center gap-2">
                        <c:if test="${not empty keyword}">
                            <input type="hidden" name="keyword" value="${keyword}" />
                        </c:if>
                        <label for="size" class="form-label mb-0 fw-semibold small text-nowrap">Page size:</label>
                        <select name="size" id="size" class="form-select form-select-sm w-auto" onchange="this.form.submit()">
                            <option ${userPage.size == 3 ? 'selected' : ''} value="3">3</option>
                            <option ${userPage.size == 5 ? 'selected' : ''} value="5">5</option>
                            <option ${userPage.size == 10 ? 'selected' : ''} value="10">10</option>
                            <option ${userPage.size == 15 ? 'selected' : ''} value="15">15</option>
                            <option ${userPage.size == 20 ? 'selected' : ''} value="20">20</option>
                        </select>
                    </form>
                </div>
            </div>

            <!-- Bảng dữ liệu -->
            <c:if test="${!userPage.hasContent()}">
                <div class="alert alert-secondary text-center py-4 mb-0">
                    <i class="bi bi-people fs-4 d-block mb-2"></i>
                    Không tìm thấy người dùng nào.
                </div>
            </c:if>

            <c:if test="${userPage.hasContent()}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 5%;">STT</th>
                                <th style="width: 6%;">ID</th>
                                <th style="width: 8%;">Avatar</th>
                                <th style="width: 14%;">Username</th>
                                <th style="width: 16%;">Họ và tên</th>
                                <th style="width: 18%;">Email</th>
                                <th style="width: 10%;">SĐT</th>
                                <th style="width: 8%;">Vai trò</th>
                                <th style="width: 7%;">Status</th>
                                <th style="width: 14%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userPage.content}" var="u" varStatus="STT">
                                <tr>
                                    <td class="fw-bold">${userPage.number * userPage.size + STT.index + 1}</td>
                                    <td><span class="badge bg-light text-dark border">#${u.id}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty u.avatar && (fn:startsWith(u.avatar, 'http://') || fn:startsWith(u.avatar, 'https://'))}">
                                                <img src="${u.avatar}" class="rounded-circle border" width="40" height="40" style="object-fit: cover;" alt="avatar"
                                                     onerror="this.src='https://placehold.co/40x40?text=U'" />
                                            </c:when>
                                            <c:when test="${not empty u.avatar}">
                                                <img src="<c:url value='/image?fname=${u.avatar}'/>" class="rounded-circle border" width="40" height="40" style="object-fit: cover;" alt="avatar"
                                                     onerror="this.src='https://placehold.co/40x40?text=U'" />
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-person-circle fs-3 text-secondary"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-semibold text-start">${u.username}</td>
                                    <td class="text-start">${u.fullname}</td>
                                    <td class="text-start small">${u.email}</td>
                                    <td class="small">${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.roleid == 1}"><span class="badge bg-danger">Admin</span></c:when>
                                            <c:when test="${u.roleid == 2}"><span class="badge bg-info text-dark">Manager</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">User</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}"><span class="badge bg-success">Active</span></c:when>
                                            <c:otherwise><span class="badge bg-warning text-dark">Khóa</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-nowrap">
                                        <a href="<c:url value='/admin/users/edit/${u.id}'/>" class="btn btn-sm btn-outline-warning me-1">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <c:if test="${sessionScope.account.id != u.id}">
                                            <form action="<c:url value='/admin/users/delete/${u.id}'/>" method="post" class="d-inline"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa tài khoản \'${fn:escapeXml(u.username)}\'?');">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang -->
                <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 gap-2">
                    <div class="small text-muted">
                        Hiển thị <strong>${userPage.numberOfElements}</strong> / <strong>${userPage.totalElements}</strong> người dùng
                        (Trang <strong>${userPage.number + 1}</strong> / <strong>${userPage.totalPages}</strong>)
                    </div>
                    <c:if test="${userPage.totalPages > 1}">
                        <nav aria-label="User pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${userPage.first ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/users/searchpaginated'><c:param name='keyword' value='${keyword}'/><c:param name='size' value='${userPage.size}'/><c:param name='page' value='1'/></c:url>">&laquo;</a>
                                </li>
                                <li class="page-item ${userPage.first ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/users/searchpaginated'><c:param name='keyword' value='${keyword}'/><c:param name='size' value='${userPage.size}'/><c:param name='page' value='${userPage.number}'/></c:url>">&lsaquo;</a>
                                </li>
                                <c:forEach items="${pageNumbers}" var="pageNumber">
                                    <li class="${pageNumber == userPage.number + 1 ? 'page-item active' : 'page-item'}">
                                        <a class="page-link" href="<c:url value='/admin/users/searchpaginated'><c:param name='keyword' value='${keyword}'/><c:param name='size' value='${userPage.size}'/><c:param name='page' value='${pageNumber}'/></c:url>">${pageNumber}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${userPage.last ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/users/searchpaginated'><c:param name='keyword' value='${keyword}'/><c:param name='size' value='${userPage.size}'/><c:param name='page' value='${userPage.number + 2}'/></c:url>">&rsaquo;</a>
                                </li>
                                <li class="page-item ${userPage.last ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/users/searchpaginated'><c:param name='keyword' value='${keyword}'/><c:param name='size' value='${userPage.size}'/><c:param name='page' value='${userPage.totalPages}'/></c:url>">&raquo;</a>
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
