<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Xác Thực Email Mới | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 500px; margin: 40px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: white; padding: 25px 20px; text-align: center; }
        .otp-input { letter-spacing: 8px; font-size: 1.6rem; text-align: center; font-weight: 700; color: #1e293b; }
    </style>
</head>
<body>
    <div class="container py-3">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-envelope-circle-check fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">XÁC THỰC EMAIL MỚI</h4>
                <p class="small text-white-50 mb-0">Cập nhật hồ sơ người dùng (Yêu cầu 3)</p>
            </div>
            <div class="card-body p-4">
                <!-- Thông báo lỗi hoặc thành công -->
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

                <!-- Hỗ trợ kiểm thử/chấm bài trực quan -->
                <c:if test="${not empty otpCode}">
                    <div class="alert alert-info border-2 shadow-sm text-center py-2 mb-3">
                        <div class="small text-muted mb-1"><i class="fa-solid fa-bell text-warning me-1"></i> Mã OTP gửi tới email mới:</div>
                        <span class="badge bg-danger fs-3 font-monospace px-3 py-1">${otpCode}</span>
                        <div class="text-muted mt-1" style="font-size: 0.75rem;">(Hệ thống gửi mã qua Jakarta Mail và hiển thị tại đây để bạn kiểm thử nhanh)</div>
                    </div>
                </c:if>

                <div class="text-center mb-3">
                    <p class="text-muted small mb-1">Hệ thống đã gửi mã OTP 6 chữ số đến địa chỉ email mới:</p>
                    <h6 class="fw-bold text-primary mb-0">${newEmail}</h6>
                </div>

                <form action="<c:url value='/profile/verify-otp'/>" method="post" class="needs-validation" novalidate>
                    <div class="mb-4">
                        <label for="otp" class="form-label fw-semibold text-center w-100">
                            NHẬP MÃ XÁC THỰC OTP <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control otp-input form-control-lg" id="otp" name="otp" maxlength="6" pattern="[0-9]{6}" value="${not empty otpCode ? otpCode : ''}" placeholder="000000" required autofocus>
                        <div class="invalid-feedback text-center">
                            Vui lòng nhập đầy đủ 6 chữ số OTP.
                        </div>
                        <div class="form-text text-center mt-2">Mã xác thực có hiệu lực trong vòng 5 phút</div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm mb-3">
                        <i class="fa-solid fa-check me-1"></i>Xác Nhận Cập Nhật Email
                    </button>

                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                        <a href="<c:url value='/profile'/>" class="btn btn-link text-decoration-none text-muted small p-0">
                            <i class="fa-solid fa-arrow-left me-1"></i>Quay lại hồ sơ
                        </a>
                        <a href="<c:url value='/profile/verify-otp?action=resend'/>" class="btn btn-link text-decoration-none text-primary fw-semibold small p-0">
                            <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                        </a>
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
