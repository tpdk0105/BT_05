<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập Nhật Sản Phẩm' : 'Thêm Sản Phẩm'}</title>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header ${isEdit ? 'bg-warning text-dark' : 'bg-success text-white'} py-3">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-circle-fill'} me-2"></i>
                        ${isEdit ? 'Cập Nhật Sản Phẩm' : 'Thêm Sản Phẩm Mới'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
                    </c:if>

                    <c:choose>
                        <c:when test="${isEdit}"><c:url value="/manager/products/update" var="formAction" /></c:when>
                        <c:otherwise><c:url value="/manager/products/insert" var="formAction" /></c:otherwise>
                    </c:choose>

                    <form action="${formAction}" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <c:if test="${isEdit}"><input type="hidden" name="id" value="${product.id}" /></c:if>

                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label fw-bold" for="name">Tên sản phẩm <span class="text-danger">*</span></label>
                                <input type="text" id="name" name="name" class="form-control" value="${product.name}" required />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold" for="categoryId">Category <span class="text-danger">*</span></label>
                                <select id="categoryId" name="categoryId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach items="${categories}" var="cate">
                                        <option value="${cate.id}" ${product.category != null && product.category.id == cate.id ? 'selected' : ''}>${cate.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold" for="price">Giá (₫) <span class="text-danger">*</span></label>
                                <input type="number" min="0" step="1" id="price" name="price" class="form-control"
                                       value="${product.price.toBigInteger()}" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold" for="quantity">Số lượng</label>
                                <input type="number" min="0" id="quantity" name="quantity" class="form-control" value="${product.quantity}" />
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold" for="description">Mô tả</label>
                                <textarea id="description" name="description" rows="3" class="form-control">${product.description}</textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold" for="images">Link ảnh (URL)</label>
                                <input type="text" id="images" name="images" class="form-control" value="${product.images}" placeholder="https://..." />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold" for="images1">Upload ảnh</label>
                                <input type="file" id="images1" name="images1" class="form-control" accept="image/*" />
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold d-block">Trạng thái</label>
                                <div class="form-check form-check-inline">
                                    <input type="radio" id="pon" name="status" value="1" class="form-check-input" ${product.status == 1 ? 'checked' : ''} />
                                    <label for="pon" class="form-check-label text-success fw-semibold">Đang bán</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input type="radio" id="poff" name="status" value="0" class="form-check-input" ${product.status != 1 ? 'checked' : ''} />
                                    <label for="poff" class="form-check-label text-secondary fw-semibold">Ẩn</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="<c:url value='/manager/products/searchpaginated'/>" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại</a>
                            <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'} fw-bold px-4">
                                ${isEdit ? 'Cập nhật' : 'Thêm mới'}
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
