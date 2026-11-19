<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Thêm Danh Mục Mới | HCMUTE Admin</title>
    <style>
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
    </style>
</head>
<body>
<div class="container py-2">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-header card-header-gradient py-3">
                    <h5 class="mb-0"><i class="fa-solid fa-folder-plus me-2"></i>THÊM MỚI DANH MỤC</h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage || not empty error}">
                        <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i>
                            <div>${not empty errorMessage ? errorMessage : error}</div>
                        </div>
                    </c:if>

                    <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data">
                        <!-- Tên danh mục -->
                        <div class="mb-3">
                            <label for="categoryname" class="form-label fw-semibold">Tên danh mục (Category name) <span class="text-danger">*</span>:</label>
                            <input type="text" class="form-control" id="categoryname" name="categoryname" value="${categoryname}" required placeholder="Nhập tên danh mục...">
                        </div>

                        <!-- Link ảnh online -->
                        <div class="mb-3">
                            <label for="images" class="form-label fw-semibold">Đường dẫn ảnh Online (Link images):</label>
                            <input type="text" class="form-control" id="images" name="images" value="${images}" placeholder="https://example.com/image.jpg">
                            <div class="form-text">Nhập URL hình ảnh trực tuyến (nếu không tải tệp lên).</div>
                        </div>

                        <!-- Tải tệp ảnh từ máy tính -->
                        <div class="mb-3">
                            <label for="images1" class="form-label fw-semibold">Tải ảnh lên từ máy tính (Upload images):</label>
                            <input type="file" class="form-control" id="images1" name="images1" accept="image/*">
                        </div>

                        <!-- Trạng thái -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block">Trạng thái (Status):</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="ston" name="status" value="1" ${status == 0 ? '' : 'checked'}>
                                <label class="form-check-label text-success fw-bold" for="ston">
                                    <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="stoff" name="status" value="0" ${status == 0 ? 'checked' : ''}>
                                <label class="form-check-label text-danger fw-bold" for="stoff">
                                    <i class="fa-solid fa-lock me-1"></i>Khóa
                                </label>
                            </div>
                        </div>

                        <!-- Nút bấm -->
                        <div class="d-flex justify-content-between">
                            <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary">
                                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">
                                <i class="fa-solid fa-check me-1"></i>Thêm Danh Mục
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
