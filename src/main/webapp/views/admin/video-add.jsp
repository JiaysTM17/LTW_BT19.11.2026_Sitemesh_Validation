<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Thêm Video Mới (Multipart Upload) | HCMUTE Admin</title>
    <style>
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
    </style>
</head>
<body>
    <div class="container py-2">
        <div class="card shadow-sm border-0" style="max-width: 800px; margin: 0 auto;">
            <div class="card-header card-header-gradient py-3">
                <h4 class="mb-0"><i class="fa-solid fa-cloud-arrow-up me-2"></i>THÊM VIDEO MỚI (MULTIPART UPLOAD)</h4>
            </div>

            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>

                <form action="<c:url value='/admin/video/insert'/>" method="post" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="videoId" class="form-label fw-semibold">Mã Video (VideoId) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control font-monospace" id="videoId" name="videoId" value="${video.videoId != null ? video.videoId : videoId}" placeholder="Ví dụ: vid01" required autofocus>
                        </div>

                        <div class="col-md-6">
                            <label for="title" class="form-label fw-semibold">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" value="${video.title != null ? video.title : title}" placeholder="Nhập tiêu đề video" required>
                        </div>

                        <div class="col-md-6">
                            <label for="categoryId" class="form-label fw-semibold">Danh Mục (Category) <span class="text-danger">*</span></label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.categoryid}" ${(video.category != null && video.category.categoryid == cat.categoryid) || categoryId == cat.categoryid ? 'selected' : ''}>${cat.categoryname}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="userId" class="form-label fw-semibold">Tác Giả (Người Đăng)</label>
                            <select class="form-select" id="userId" name="userId">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}" ${sessionScope.account != null && sessionScope.account.id == u.id ? 'selected' : ''}>
                                        ${u.username} (${u.fullname != null ? u.fullname : 'N/A'})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="posterFile" class="form-label fw-semibold">Tải Lên Poster Ảnh (File)</label>
                            <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                            <div class="form-text">Chọn tệp ảnh từ máy (PNG, JPG, WEBP)</div>
                        </div>

                        <div class="col-md-6">
                            <label for="posterUrl" class="form-label fw-semibold">Hoặc Nhập URL Poster Trực Tuyến</label>
                            <input type="text" class="form-control" id="posterUrl" name="posterUrl" value="${video.poster != null ? video.poster : posterUrl}" placeholder="https://images.unsplash.com/...">
                        </div>

                        <div class="col-md-6">
                            <label for="videoFile" class="form-label fw-semibold">Tải Lên File Video MP4 (File)</label>
                            <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/*">
                            <div class="form-text">Hỗ trợ định dạng MP4 tối đa 100MB</div>
                        </div>

                        <div class="col-md-6">
                            <label for="videoUrl" class="form-label fw-semibold">Hoặc Nhập URL Video / Tên File Sẵn</label>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl" value="${video.videoUrl != null ? video.videoUrl : videoUrl}" placeholder="demo.mp4 hoặc https://...">
                        </div>

                        <div class="col-12">
                            <label for="description" class="form-label fw-semibold">Mô Tả Video</label>
                            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập tóm tắt nội dung video">${video.description != null ? video.description : description}</textarea>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold d-block">Trạng Thái Kích Hoạt</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active1" value="1" checked>
                                <label class="form-check-label text-success fw-bold" for="active1">
                                    <i class="fa-solid fa-circle-check me-1"></i>Công khai (Kích hoạt)
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active0" value="0">
                                <label class="form-check-label text-secondary fw-bold" for="active0">
                                    <i class="fa-solid fa-eye-slash me-1"></i>Ẩn video
                                </label>
                            </div>
                        </div>

                        <div class="col-12 d-flex justify-content-between pt-3 border-top">
                            <a href="<c:url value='/admin/videos'/>" class="btn btn-outline-secondary">
                                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">
                                <i class="fa-solid fa-cloud-arrow-up me-1"></i>Lưu & Thêm Video
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
