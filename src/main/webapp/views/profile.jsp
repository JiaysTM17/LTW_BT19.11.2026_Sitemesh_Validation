<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Hồ Sơ Cá Nhân | HCMUTE JPA</title>
    <style>
        .profile-card { max-width: 800px; margin: 30px auto; border-radius: 16px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.08); overflow: hidden; }
        .profile-header { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; padding: 30px 24px; text-align: center; }
        .avatar-wrapper { position: relative; width: 130px; height: 130px; margin: 0 auto 15px; }
        .avatar-img { width: 130px; height: 130px; object-fit: cover; border-radius: 50%; border: 4px solid white; box-shadow: 0 4px 12px rgba(0,0,0,0.15); background-color: #fff; }
        .avatar-badge { position: absolute; bottom: 0; right: 5px; background: #10b981; color: white; border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; border: 2px solid white; }
    </style>
</head>
<body>
    <div class="container py-3">
        <div class="card profile-card">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty user.avatar && user.avatar.startsWith('http')}">
                            <img id="avatarPreview" src="${user.avatar}" alt="Avatar" class="avatar-img"
                                 onerror="this.src='https://ui-avatars.com/api/?name=${user.fullname}&background=random&size=130'">
                        </c:when>
                        <c:when test="${not empty user.avatar}">
                            <img id="avatarPreview" src="<c:url value='/image?fname=${user.avatar}'/>" alt="Avatar" class="avatar-img"
                                 onerror="this.src='https://ui-avatars.com/api/?name=${user.fullname}&background=random&size=130'">
                        </c:when>
                        <c:otherwise>
                            <img id="avatarPreview" src="https://ui-avatars.com/api/?name=${user.fullname}&background=random&size=130" alt="Avatar" class="avatar-img">
                        </c:otherwise>
                    </c:choose>
                    <span class="avatar-badge" title="Tài khoản hợp lệ">
                        <i class="fa-solid fa-check"></i>
                    </span>
                </div>
                <h3 class="fw-bold mb-1">${user.fullname}</h3>
                <p class="mb-0 text-white-50">@${user.username} &bull; 
                    <span class="badge bg-light text-dark px-2 py-1">
                        <c:choose>
                            <c:when test="${user.roleid == 2}"><i class="fa-solid fa-shield-halved text-danger me-1"></i>Quản Trị Viên (Admin)</c:when>
                            <c:otherwise><i class="fa-solid fa-user text-primary me-1"></i>Thành Viên (User)</c:otherwise>
                        </c:choose>
                    </span>
                </p>
            </div>

            <!-- Profile Body -->
            <div class="card-body p-4 p-md-5">
                <!-- Thông báo lỗi hoặc thành công -->
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-4" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2 fa-lg"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage || not empty message}">
                    <div class="alert alert-success py-2 small d-flex align-items-center mb-4" role="alert">
                        <i class="fa-solid fa-circle-check me-2 fa-lg"></i>
                        <div>${not empty successMessage ? successMessage : message}</div>
                    </div>
                </c:if>

                <form action="<c:url value='/profile'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <div class="row g-3">
                        <!-- Tên đăng nhập (Read-only) -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">
                                <i class="fa-solid fa-user-lock me-1"></i>Tên đăng nhập
                            </label>
                            <input type="text" class="form-control bg-light" value="${user.username}" readonly>
                            <div class="form-text">Tên đăng nhập là cố định, không thể thay đổi.</div>
                        </div>

                        <!-- Ngày tạo tài khoản (Read-only) -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">
                                <i class="fa-solid fa-calendar-days me-1"></i>Ngày tham gia
                            </label>
                            <input type="text" class="form-control bg-light" value="${user.createddate}" readonly>
                            <div class="form-text">Thời điểm kích hoạt tài khoản trên hệ thống.</div>
                        </div>

                        <!-- Họ và tên -->
                        <div class="col-md-12">
                            <label for="fullname" class="form-label fw-semibold">
                                <i class="fa-solid fa-id-card me-1 text-primary"></i>Họ và tên <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${user.fullname}" minlength="2" required placeholder="Nhập họ và tên của bạn">
                            <div class="invalid-feedback">
                                Vui lòng nhập họ và tên (tối thiểu 2 ký tự).
                            </div>
                        </div>

                        <!-- Email (Có xác thực OTP khi cập nhật mới) -->
                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold">
                                <i class="fa-solid fa-envelope me-1 text-primary"></i>Địa chỉ Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required placeholder="user@example.com">
                            <div class="invalid-feedback">
                                Vui lòng nhập địa chỉ email hợp lệ.
                            </div>
                            <div class="form-text text-warning">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i>
                                <strong>Lưu ý:</strong> Nếu đổi email mới, hệ thống sẽ gửi mã OTP đến email mới để bạn xác thực thành công.
                            </div>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold">
                                <i class="fa-solid fa-phone me-1 text-primary"></i>Số điện thoại
                            </label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" pattern="^(0|\+84)[0-9]{9,10}$" placeholder="0987654321">
                            <div class="invalid-feedback">
                                Số điện thoại phải gồm 10 chữ số (bắt đầu bằng 0 hoặc +84).
                            </div>
                            <div class="form-text">Dùng để liên hệ hoặc nhận thông báo khẩn.</div>
                        </div>

                        <!-- Upload Avatar (Cloudinary Multipart) -->
                        <div class="col-md-12">
                            <div class="p-3 border rounded-3 bg-light">
                                <label for="image" class="form-label fw-semibold mb-1">
                                    <i class="fa-solid fa-cloud-arrow-up me-1 text-info"></i>Ảnh đại diện (Upload Cloudinary Multipart)
                                </label>
                                <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                <div class="form-text text-muted mt-2">
                                    <i class="fa-solid fa-circle-info me-1"></i>
                                    Hình ảnh được tải lên bằng cơ chế <code>Multipart</code> và lưu trữ trên <strong>Cloudinary Cloud</strong>. Hỗ trợ định dạng JPG, PNG, WEBP tối đa 10MB.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Nút thao tác -->
                    <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                        <a href="<c:url value='/home'/>" class="btn btn-outline-secondary px-4">
                            <i class="fa-solid fa-arrow-left me-1"></i>Về Trang Chủ
                        </a>
                        <button type="submit" class="btn btn-primary px-5 py-2 fw-semibold shadow-sm">
                            <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Thay Đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Script xem trước ảnh tức thời & validation -->
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

            // Xem trước ảnh khi chọn file
            const imageInput = document.getElementById('image');
            const avatarPreview = document.getElementById('avatarPreview');
            if (imageInput && avatarPreview) {
                imageInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function(evt) {
                            avatarPreview.src = evt.target.result;
                        };
                        reader.readAsDataURL(file);
                    }
                });
            }
        })();
    </script>
</body>
