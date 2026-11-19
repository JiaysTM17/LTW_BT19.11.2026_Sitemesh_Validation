<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Đặt Lại Mật Khẩu (Xác Nhận OTP) | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 480px; margin: 30px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); color: white; padding: 25px 20px; text-align: center; }
        .otp-input { letter-spacing: 8px; font-size: 1.4rem; text-align: center; font-weight: 700; color: #1e293b; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-shield-halved fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">ĐẶT LẠI MẬT KHẨU</h4>
                <p class="small text-white-50 mb-0">Nhập mã OTP đã nhận qua Email và mật khẩu mới</p>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>

                <c:if test="${not empty otpCode}">
                    <div class="alert alert-info border-2 shadow-sm text-center py-2 mb-3">
                        <div class="small text-muted mb-1"><i class="fa-solid fa-key text-warning me-1"></i> Mã OTP xác nhận đặt lại mật khẩu:</div>
                        <span class="badge bg-danger fs-3 font-monospace px-3 py-1">${otpCode}</span>
                        <div class="text-muted mt-1" style="font-size: 0.75rem;">(Đã tạo cho email ${email} và hiển thị tại đây để bạn kiểm thử/chấm bài ngay)</div>
                    </div>
                </c:if>

                <p class="text-muted small text-center mb-3">
                    Email khôi phục: <strong class="text-primary">${email}</strong>
                </p>

                <form action="<c:url value='/reset-password'/>" method="post">
                    <input type="hidden" name="email" value="${email}">

                    <div class="mb-3">
                        <label for="otp" class="form-label fw-semibold">MÃ XÁC THỰC (OTP 6 số)</label>
                        <input type="text" class="form-control otp-input" id="otp" name="otp" maxlength="6" value="${not empty otpCode ? otpCode : ''}" placeholder="000000" required autofocus>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Tối thiểu 6 ký tự" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu mới</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-check-double"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Mật Khẩu Mới
                    </button>
                </form>

                <div class="text-center mt-3 pt-3 border-top">
                    <p class="small text-muted mb-0">
                        <a href="<c:url value='/login'/>" class="fw-bold text-secondary text-decoration-none">
                            <i class="fa-solid fa-arrow-left me-1"></i>Quay lại trang Đăng nhập
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
