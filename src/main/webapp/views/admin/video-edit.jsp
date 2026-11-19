<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Video [${video.videoId}] | HCMUTE Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .preview-img { width: 140px; height: 90px; object-fit: cover; border-radius: 8px; border: 2px solid #cbd5e1; }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container py-4">
        <div class="card shadow-sm border-0" style="max-width: 800px; margin: 0 auto;">
            <div class="card-header card-header-gradient py-3">
                <h4 class="mb-0"><i class="fa-solid fa-pen-to-square me-2"></i>CẬP NHẬT VIDEO [${video.videoId}]</h4>
            </div>

            <div class="card-body p-4">
                <form action="<c:url value='/admin/video/update'/>" method="post" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="videoId" class="form-label fw-semibold">Mã Video (Không được sửa)</label>
                            <input type="text" class="form-control font-monospace bg-light" id="videoId" name="videoId" value="${video.videoId}" readonly>
                        </div>

                        <div class="col-md-6">
                            <label for="title" class="form-label fw-semibold">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" value="${video.title}" required>
                        </div>

                        <div class="col-md-6">
                            <label for="categoryId" class="form-label fw-semibold">Danh Mục (Category)</label>
                            <select class="form-select" id="categoryId" name="categoryId">
                                <option value="0">-- Chọn danh mục --</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.categoryid}" ${video.category != null && video.category.categoryid == cat.categoryid ? 'selected' : ''}>
                                        ${cat.categoryname}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="userId" class="form-label fw-semibold">Người Đăng (User Tác Giả)</label>
                            <select class="form-select" id="userId" name="userId">
                                <option value="0">-- Chọn người đăng --</option>
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}" ${video.user != null && video.user.id == u.id ? 'selected' : ''}>
                                        ${u.fullname != null ? u.fullname : u.username} (${u.email})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold d-block">Poster Hiện Tại</label>
                            <div class="mb-2">
                                <c:choose>
                                    <c:when test="${video.poster != null && video.poster.startsWith('http')}">
                                        <img src="${video.poster}" alt="Poster" class="preview-img">
                                    </c:when>
                                    <c:when test="${video.poster != null && !video.poster.isEmpty()}">
                                        <img src="<c:url value='/image?fname=${video.poster}'/>" alt="Poster" class="preview-img"
                                             onerror="this.src='https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=200'">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Chưa có ảnh</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <label for="posterFile" class="form-label fw-semibold">Thay đổi file Poster mới</label>
                            <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                            <input type="text" class="form-control mt-2" id="posterUrl" name="posterUrl" value="${video.poster}" placeholder="Hoặc URL ảnh online">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold d-block">Video Hiện Tại</label>
                            <div class="mb-2 text-truncate small text-secondary">
                                <i class="fa-solid fa-film me-1"></i>${video.videoUrl}
                            </div>
                            <label for="videoFile" class="form-label fw-semibold">Thay đổi file Video mới (.mp4)</label>
                            <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/*">
                            <input type="text" class="form-control mt-2" id="videoUrl" name="videoUrl" value="${video.videoUrl}" placeholder="Hoặc URL video .mp4 online">
                        </div>

                        <div class="col-12">
                            <label for="description" class="form-label fw-semibold">Mô Tả Nội Dung Video</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${video.description}</textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold d-block">Trạng Thái Hiển Thị</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active1" value="1" ${video.active == 1 ? 'checked' : ''}>
                                <label class="form-check-label" for="active1">Hoạt động (Hiển thị)</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active0" value="0" ${video.active == 0 ? 'checked' : ''}>
                                <label class="form-check-label" for="active0">Khóa (Ẩn)</label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                        <a href="<c:url value='/admin/videos'/>" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary fw-bold px-4">
                            <i class="fa-solid fa-floppy-disk me-1"></i>Cập Nhật Video
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
