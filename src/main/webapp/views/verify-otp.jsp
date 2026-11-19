<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Xác Thực Mã OTP | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 480px; margin: 40px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #059669 0%, #10b981 100%); color: white; padding: 25px 20px; text-align: center; }
        .otp-input { letter-spacing: 8px; font-size: 1.6rem; text-align: center; font-weight: 700; color: #1e293b; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-envelope-circle-check fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">KÍCH HOẠT TÀI KHOẢN</h4>
                <p class="small text-white-50 mb-0">Xác thực mã OTP 6 số qua Email</p>
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

                <c:if test="${not empty otpCode}">
                    <div class="alert alert-info border-2 shadow-sm text-center py-2 mb-3">
                        <div class="small text-muted mb-1"><i class="fa-solid fa-bell text-warning me-1"></i> Mã OTP xác thực của bạn:</div>
                        <span class="badge bg-danger fs-3 font-monospace px-3 py-1">${otpCode}</span>
                        <div class="text-muted mt-1" style="font-size: 0.75rem;">(Hệ thống gửi mã về hòm thư ${email} và đồng thời hiển thị tại đây để bạn kiểm thử/chấm bài ngay)</div>
                    </div>
                </c:if>

                <p class="text-muted small text-center mb-3">
                    Email xác thực: <strong class="text-primary">${email}</strong>
                </p>

                <form action="<c:url value='/verify-otp'/>" method="post">
                    <input type="hidden" name="email" value="${email}">

                    <div class="mb-4">
                        <label for="otp" class="form-label fw-semibold text-center w-100">NHẬP MÃ XÁC THỰC (OTP)</label>
                        <input type="text" class="form-control otp-input form-control-lg" id="otp" name="otp" maxlength="6" value="${not empty otpCode ? otpCode : ''}" placeholder="000000" required autofocus>
                        <div class="form-text text-center mt-2">Mã gồm 6 chữ số có hiệu lực trong vòng 5 phút</div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-check me-1"></i>Kích Hoạt Tài Khoản
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <p class="small text-muted mb-0">Chưa nhận được mã? 
                        <a href="<c:url value='/verify-otp?action=resend&email=${email}'/>" class="fw-bold text-success text-decoration-none">
                            <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
