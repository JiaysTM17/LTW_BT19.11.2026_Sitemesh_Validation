<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Danh Mục Mới - JPA 3.0</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-header card-header-gradient py-3">
                    <h5 class="mb-0"><i class="fa-solid fa-folder-plus me-2"></i>THÊM MỚI DANH MỤC</h5>
                </div>
                <div class="card-body p-4">
                    <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data">
                        <!-- Tên danh mục -->
                        <div class="mb-3">
                            <label for="categoryname" class="form-label fw-semibold">Tên danh mục (Category name):</label>
                            <input type="text" class="form-control" id="categoryname" name="categoryname" required placeholder="Nhập tên danh mục...">
                        </div>

                        <!-- Link ảnh online -->
                        <div class="mb-3">
                            <label for="images" class="form-label fw-semibold">Đường dẫn ảnh Online (Link images):</label>
                            <input type="text" class="form-control" id="images" name="images" placeholder="https://example.com/image.jpg">
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
                                <input class="form-check-input" type="radio" id="ston" name="status" value="1" checked>
                                <label class="form-check-label text-success fw-bold" for="ston">
                                    <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="stoff" name="status" value="0">
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
</html>
