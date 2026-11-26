<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" default="Quản Trị - Hệ Thống ABC" /></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <sitemesh:write property="head" />
</head>
<body class="bg-light d-flex flex-column min-vh-100">

    <%@ include file="/commons/admin/header.jsp" %>

    <div class="container-fluid py-4 flex-grow-1">
        <div class="row g-4">
            <div class="col-lg-2 col-md-3">
                <%@ include file="/commons/admin/left.jsp" %>
            </div>
            <div class="col-lg-10 col-md-9">
                <sitemesh:write property="body" />
            </div>
        </div>
    </div>

    <%@ include file="/commons/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
