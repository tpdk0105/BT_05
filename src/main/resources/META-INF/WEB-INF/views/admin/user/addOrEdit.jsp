<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập Nhật Người Dùng' : 'Thêm Người Dùng Mới'}</title>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header ${isEdit ? 'bg-warning text-dark' : 'bg-success text-white'} py-3">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-person-plus-fill'} me-2"></i>
                        ${isEdit ? 'Cập Nhật Người Dùng (Edit User)' : 'Thêm Người Dùng Mới (Add User)'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${isEdit}">
                            <c:url value="/admin/users/update" var="formAction" />
                        </c:when>
                        <c:otherwise>
                            <c:url value="/admin/users/insert" var="formAction" />
                        </c:otherwise>
                    </c:choose>

                    <form action="${formAction}" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <c:if test="${isEdit}">
                            <input type="hidden" name="id" value="${user.id}" />
                        </c:if>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-bold">Username <span class="text-danger">*</span></label>
                                <input type="text" id="username" name="username" class="form-control"
                                       placeholder="Tên đăng nhập (3-50 ký tự)" value="${user.username}" required />
                            </div>

                            <div class="col-md-6">
                                <label for="fullname" class="form-label fw-bold">Họ và tên</label>
                                <input type="text" id="fullname" name="fullname" class="form-control"
                                       placeholder="Nhập họ tên" value="${user.fullname}" />
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                                <input type="email" id="email" name="email" class="form-control"
                                       placeholder="example@gmail.com" value="${user.email}" required />
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-bold">Số điện thoại</label>
                                <input type="tel" id="phone" name="phone" class="form-control"
                                       placeholder="VD: 0901234567" value="${user.phone}" />
                            </div>

                            <div class="col-md-6">
                                <label for="password" class="form-label fw-bold">
                                    Mật khẩu
                                    <c:if test="${!isEdit}"><span class="text-danger">*</span></c:if>
                                    <c:if test="${isEdit}"><span class="text-muted small fw-normal">(để trống nếu không đổi)</span></c:if>
                                </label>
                                <input type="password" id="password" name="password" class="form-control"
                                       placeholder="${isEdit ? 'Nhập mật khẩu mới nếu muốn đổi' : 'Ít nhất 6 ký tự'}"
                                       ${isEdit ? '' : 'required minlength="6"'} />
                            </div>

                            <div class="col-md-6">
                                <label for="roleid" class="form-label fw-bold">Vai trò (Role)</label>
                                <select id="roleid" name="roleid" class="form-select">
                                    <option value="1" ${user.roleid == 1 ? 'selected' : ''}>1 - Admin</option>
                                    <option value="2" ${user.roleid == 2 ? 'selected' : ''}>2 - Manager</option>
                                    <option value="3" ${user.roleid == 3 ? 'selected' : ''}>3 - User</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="avatar" class="form-label fw-bold">Link Avatar (URL)</label>
                                <input type="text" id="avatar" name="avatar" class="form-control"
                                       placeholder="https://... (nếu có)" value="${user.avatar}" />
                            </div>

                            <div class="col-md-6">
                                <label for="avatarFile" class="form-label fw-bold">Upload Avatar</label>
                                <input type="file" id="avatarFile" name="avatarFile" class="form-control" accept="image/*" />
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold d-block">Trạng thái tài khoản</label>
                                <div class="form-check form-check-inline">
                                    <input type="radio" id="uston" name="status" value="1" class="form-check-input" ${user.status == 1 ? 'checked' : ''} />
                                    <label for="uston" class="form-check-label text-success fw-semibold">Hoạt động (Active)</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input type="radio" id="ustoff" name="status" value="0" class="form-check-input" ${user.status != 1 ? 'checked' : ''} />
                                    <label for="ustoff" class="form-check-label text-secondary fw-semibold">Khóa (Locked)</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="<c:url value='/admin/users/searchpaginated'/>" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại
                            </a>
                            <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'} fw-bold px-4">
                                <i class="bi ${isEdit ? 'bi-save' : 'bi-person-check-fill'} me-1"></i>
                                ${isEdit ? 'Cập nhật (Update)' : 'Thêm mới (Insert)'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
