<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Video Mới (Multipart Upload) | HCMUTE Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container py-4">
        <div class="card shadow-sm border-0" style="max-width: 800px; margin: 0 auto;">
            <div class="card-header card-header-gradient py-3">
                <h4 class="mb-0"><i class="fa-solid fa-cloud-arrow-up me-2"></i>THÊM VIDEO MỚI (MULTIPART UPLOAD)</h4>
            </div>

            <div class="card-body p-4">
                <form action="<c:url value='/admin/video/insert'/>" method="post" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="videoId" class="form-label fw-semibold">Mã Video (VideoId) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control font-monospace" id="videoId" name="videoId" placeholder="Ví dụ: vid01" required autofocus>
                        </div>

                        <div class="col-md-6">
                            <label for="title" class="form-label fw-semibold">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Nhập tiêu đề video" required>
                        </div>

                        <div class="col-md-6">
                            <label for="categoryId" class="form-label fw-semibold">Danh Mục (Category)</label>
                            <select class="form-select" id="categoryId" name="categoryId">
                                <option value="0">-- Chọn danh mục --</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.categoryid}">${cat.categoryname}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="userId" class="form-label fw-semibold">Người Đăng (User Tác Giả)</label>
                            <select class="form-select" id="userId" name="userId">
                                <option value="0">-- Mặc định (Tài khoản đang đăng nhập) --</option>
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.fullname != null ? u.fullname : u.username} (${u.email})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="posterFile" class="form-label fw-semibold">Upload Poster Hình Ảnh (Multipart)</label>
                            <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                            <div class="form-text">File ảnh sẽ được lưu trữ vào thư mục cấu hình D:/upload</div>
                        </div>

                        <div class="col-md-6">
                            <label for="posterUrl" class="form-label fw-semibold">Hoặc Đường Dẫn Poster Trực Tuyến (URL)</label>
                            <input type="text" class="form-control" id="posterUrl" name="posterUrl" placeholder="https://... ảnh online">
                        </div>

                        <div class="col-md-6">
                            <label for="videoFile" class="form-label fw-semibold">Upload File Video .mp4 (Multipart)</label>
                            <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/*">
                            <div class="form-text">Upload file video mp4 theo slide hướng dẫn</div>
                        </div>

                        <div class="col-md-6">
                            <label for="videoUrl" class="form-label fw-semibold">Hoặc Đường Dẫn Video Trực Tuyến (URL .mp4)</label>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl" placeholder="https://commondatastorage.googleapis.com/.../video.mp4">
                        </div>

                        <div class="col-12">
                            <label for="description" class="form-label fw-semibold">Mô Tả Nội Dung Video</label>
                            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả chi tiết nội dung video..."></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold d-block">Trạng Thái Hiển Thị</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active1" value="1" checked>
                                <label class="form-check-label" for="active1">Hoạt động (Hiển thị)</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" id="active0" value="0">
                                <label class="form-check-label" for="active0">Khóa (Ẩn)</label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                        <a href="<c:url value='/admin/videos'/>" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary fw-bold px-4">
                            <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Video
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
