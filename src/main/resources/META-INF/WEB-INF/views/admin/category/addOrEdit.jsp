<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập Nhật Thể Loại' : 'Thêm Thể Loại Mới'}</title>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header ${isEdit ? 'bg-warning text-dark' : 'bg-success text-white'} py-3">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-circle-fill'} me-2"></i>
                        ${isEdit ? 'Cập Nhật Thể Loại (Edit Category)' : 'Thêm Thể Loại Mới (Add Category)'}
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
                            <c:url value="/admin/categories/update" var="formAction" />
                        </c:when>
                        <c:otherwise>
                            <c:url value="/admin/categories/insert" var="formAction" />
                        </c:otherwise>
                    </c:choose>

                    <form action="${formAction}" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <c:if test="${isEdit}">
                            <input type="hidden" name="id" value="${category.id}" />
                        </c:if>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Tên thể loại (Category Name) <span class="text-danger">*</span></label>
                            <input type="text" id="name" name="name" class="form-control"
                                   placeholder="Nhập tên thể loại" value="${category.name}" required />
                        </div>

                        <div class="mb-3">
                            <label for="images" class="form-label fw-bold">Link hình ảnh (URL)</label>
                            <input type="text" id="images" name="images" class="form-control"
                                   placeholder="https://... (nếu dùng ảnh từ link)" value="${category.images}" />
                        </div>

                        <c:if test="${isEdit && not empty category.images}">
                            <div class="mb-3">
                                <label class="form-label fw-bold d-block">Hình ảnh hiện tại:</label>
                                <c:choose>
                                    <c:when test="${fn:startsWith(category.images, 'http://') || fn:startsWith(category.images, 'https://')}">
                                        <c:set var="previewUrl" value="${category.images}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image?fname=${category.images}" var="previewUrl" />
                                    </c:otherwise>
                                </c:choose>
                                <img height="110" width="150" src="${previewUrl}" class="rounded shadow-sm img-thumbnail"
                                     style="object-fit: cover;" alt="${category.name}"
                                     onerror="this.src='https://placehold.co/150x110?text=No+Image'" />
                            </div>
                        </c:if>

                        <div class="mb-3">
                            <label for="images1" class="form-label fw-bold">
                                ${isEdit ? 'Upload ảnh mới (thay thế ảnh cũ nếu chọn):' : 'Upload hình ảnh từ máy:'}
                            </label>
                            <input type="file" id="images1" name="images1" class="form-control" accept="image/*" />
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold d-block">Trạng thái (Status)</label>
                            <div class="form-check form-check-inline">
                                <input type="radio" id="ston" name="status" value="1" class="form-check-input" ${category.status == 1 ? 'checked' : ''} />
                                <label for="ston" class="form-check-label text-success fw-semibold">Hoạt động</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input type="radio" id="stoff" name="status" value="0" class="form-check-input" ${category.status != 1 ? 'checked' : ''} />
                                <label for="stoff" class="form-check-label text-secondary fw-semibold">Khóa</label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <a href="<c:url value='/admin/categories/searchpaginated'/>" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại
                            </a>
                            <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'} fw-bold px-4">
                                <i class="bi ${isEdit ? 'bi-save' : 'bi-plus-lg'} me-1"></i>
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
