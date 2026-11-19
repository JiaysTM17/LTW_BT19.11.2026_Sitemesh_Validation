<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Cập Nhật Danh Mục | HCMUTE Admin</title>
    <style>
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .img-preview { width: 160px; height: 120px; object-fit: cover; border-radius: 8px; border: 2px solid #e2e8f0; }
    </style>
</head>
<body>
<div class="container py-2">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-header card-header-gradient py-3">
                    <h5 class="mb-0"><i class="fa-solid fa-pen-to-square me-2"></i>CHỈNH SỬA DANH MỤC</h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage || not empty error}">
                        <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i>
                            <div>${not empty errorMessage ? errorMessage : error}</div>
                        </div>
                    </c:if>

                    <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data">
                        <!-- ID ẩn -->
                        <input type="hidden" name="categoryid" value="${cate.categoryid}">

                        <!-- Tên danh mục -->
                        <div class="mb-3">
                            <label for="categoryname" class="form-label fw-semibold">Tên danh mục (Category name) <span class="text-danger">*</span>:</label>
                            <input type="text" class="form-control" id="categoryname" name="categoryname" value="${cate.categoryname}" required>
                        </div>

                        <!-- Link ảnh online -->
                        <div class="mb-3">
                            <label for="images" class="form-label fw-semibold">Đường dẫn ảnh Online (Link images):</label>
                            <input type="text" class="form-control" id="images" name="images" value="${cate.images}">
                        </div>

                        <!-- Ảnh hiện tại -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold d-block">Hình ảnh hiện tại:</label>
                            <c:choose>
                                <c:when test="${cate.images != null && cate.images.startsWith('http')}">
                                    <c:url value="${cate.images}" var="imgUrl"/>
                                </c:when>
                                <c:otherwise>
                                    <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                </c:otherwise>
                            </c:choose>
                            <img src="${imgUrl}" class="img-preview mb-2" alt="${cate.categoryname}"
                                 onerror="this.src='https://placehold.co/160x120?text=No+Image'"/>
                        </div>

                        <!-- Tải tệp ảnh thay thế -->
                        <div class="mb-3">
                            <label for="images1" class="form-label fw-semibold">Tải ảnh mới thay thế (Upload images):</label>
                            <input type="file" class="form-control" id="images1" name="images1" accept="image/*">
                            <div class="form-text">Nếu không chọn ảnh mới, hệ thống sẽ giữ lại ảnh hiện tại.</div>
                        </div>

                        <!-- Trạng thái -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block">Trạng thái (Status):</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}>
                                <label class="form-check-label text-success fw-bold" for="ston">
                                    <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}>
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
                            <button type="submit" class="btn btn-warning px-4 fw-bold text-dark">
                                <i class="fa-solid fa-floppy-disk me-1"></i>Cập Nhật Danh Mục
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
