<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Chỉnh Sửa Video [${video.videoId}] | HCMUTE Admin</title>
    <style>
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .preview-img { width: 140px; height: 90px; object-fit: cover; border-radius: 8px; border: 2px solid #cbd5e1; }
    </style>
</head>
<body>
    <div class="container py-2">
        <div class="card shadow-sm border-0" style="max-width: 800px; margin: 0 auto;">
            <div class="card-header card-header-gradient py-3">
                <h4 class="mb-0"><i class="fa-solid fa-pen-to-square me-2"></i>CẬP NHẬT VIDEO [${video.videoId}]</h4>
            </div>

            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage || not empty message}">
                    <div class="alert alert-success py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i>
                        <div>${not empty successMessage ? successMessage : message}</div>
                    </div>
                </c:if>

                <form action="<c:url value='/admin/video/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="videoId" class="form-label fw-semibold">Mã Video (Không được sửa)</label>
                            <input type="text" class="form-control font-monospace bg-light" id="videoId" name="videoId" value="${video.videoId}" readonly>
                        </div>

                        <div class="col-md-6">
                            <label for="title" class="form-label fw-semibold">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" value="${video.title}" minlength="3" required>
                            <div class="invalid-feedback">
                                Vui lòng nhập tiêu đề video (tối thiểu 3 ký tự).
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="categoryId" class="form-label fw-semibold">Danh Mục (Category) <span class="text-danger">*</span></label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.categoryid}" ${video.category != null && video.category.categoryid == cat.categoryid ? 'selected' : ''}>
                                        ${cat.categoryname}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Vui lòng chọn danh mục hợp lệ.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="userId" class="form-label fw-semibold">Tác Giả (Người Đăng)</label>
                            <select class="form-select" id="userId" name="userId">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}" ${video.user != null && video.user.id == u.id ? 'selected' : ''}>
                                        ${u.username} (${u.fullname != null ? u.fullname : 'N/A'})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold d-block">Poster Hiện Tại</label>
                            <c:choose>
                                <c:when test="${video.poster != null && video.poster.startsWith('http')}">
                                    <img src="${video.poster}" alt="Poster" class="preview-img mb-2">
                                </c:when>
                                <c:when test="${video.poster != null && !video.poster.isEmpty()}">
                                    <img src="<c:url value='/image?fname=${video.poster}'/>" alt="Poster" class="preview-img mb-2"
                                         onerror="this.src='https://placehold.co/140x90?text=No+Poster'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://placehold.co/140x90?text=No+Poster" alt="No poster" class="preview-img mb-2">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-md-6">
                            <label for="posterFile" class="form-label fw-semibold">Tải Poster Mới (Thay thế)</label>
                            <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                            <div class="form-text">Bỏ trống nếu muốn giữ nguyên poster hiện tại.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="posterUrl" class="form-label fw-semibold">Hoặc Đổi URL Poster Online</label>
                            <input type="text" class="form-control" id="posterUrl" name="posterUrl" value="${video.poster}">
                        </div>

                        <div class="col-md-6">
                            <label for="videoFile" class="form-label fw-semibold">Tải Lên Video File Mới (Thay thế)</label>
                            <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/*">
                            <div class="form-text">Bỏ trống nếu muốn giữ nguyên video hiện tại.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="videoUrl" class="form-label fw-semibold">Tên File Video / URL Video Hiện Tại</label>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl" value="${video.videoUrl}">
                        </div>

                        <div class="col-md-6">
                            <label for="views" class="form-label fw-semibold">Lượt Xem (Views)</label>
                            <input type="number" class="form-control" id="views" name="views" value="${video.views}" min="0">
                        </div>

                        <div class="col-12">
                            <label for="description" class="form-label fw-semibold">Mô Tả Video</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${video.description}</textarea>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold d-block">Trạng Thái Kích Hoạt</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active1" value="1" ${video.active == 1 ? 'checked' : ''}>
                                <label class="form-check-label text-success fw-bold" for="active1">
                                    <i class="fa-solid fa-circle-check me-1"></i>Công khai (Kích hoạt)
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active0" value="0" ${video.active != 1 ? 'checked' : ''}>
                                <label class="form-check-label text-secondary fw-bold" for="active0">
                                    <i class="fa-solid fa-eye-slash me-1"></i>Ẩn video
                                </label>
                            </div>
                        </div>

                        <div class="col-12 d-flex justify-content-between pt-3 border-top">
                            <a href="<c:url value='/admin/videos'/>" class="btn btn-outline-secondary">
                                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-warning px-4 fw-bold text-dark shadow-sm">
                                <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Thay Đổi
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        (function() {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
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
