<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Đăng Ký Tài Khoản (Kích Hoạt OTP) | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 500px; margin: 30px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%); color: white; padding: 25px 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-user-plus fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">ĐĂNG KÝ TÀI KHOẢN</h4>
                <p class="small text-white-50 mb-0">Mã kích hoạt OTP 6 số sẽ được gửi qua Email</p>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>

                <form id="registerForm" action="<c:url value='/register'/>" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-at"></i></span>
                            <input type="text" class="form-control" id="username" name="username" value="${not empty username ? username : param.username}" placeholder="Ví dụ: kiettg" pattern="^[a-zA-Z0-9_]{3,30}$" required autofocus>
                            <div class="invalid-feedback">
                                Tên đăng nhập từ 3-30 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới (_).
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email (Nhận mã OTP) <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${not empty email ? email : param.email}" placeholder="example@gmail.com" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" required>
                            <div class="invalid-feedback">
                                Vui lòng nhập địa chỉ email hợp lệ (ví dụ: user@example.com).
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-id-card"></i></span>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${not empty fullname ? fullname : param.fullname}" placeholder="Ví dụ: Trương Gia Kiệt" maxlength="100">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                            <input type="tel" class="form-control" id="phone" name="phone" value="${not empty phone ? phone : param.phone}" placeholder="Ví dụ: 0987654321" pattern="^(0|\+84)[0-9]{9,10}$">
                            <div class="invalid-feedback">
                                Số điện thoại phải gồm 10 chữ số (bắt đầu bằng số 0 hoặc +84).
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Tối thiểu 6 ký tự" minlength="6" required>
                            <div class="invalid-feedback">
                                Mật khẩu phải có tối thiểu 6 ký tự.
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-shield-halved"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" minlength="6" required>
                            <div class="invalid-feedback" id="confirmPasswordFeedback">
                                Mật khẩu xác nhận không khớp hoặc chưa nhập.
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-paper-plane me-1"></i>Đăng Ký & Nhận OTP
                    </button>
                </form>

                <div class="text-center mt-3 pt-3 border-top">
                    <p class="small text-muted mb-0">Đã có tài khoản? 
                        <a href="<c:url value='/login'/>" class="fw-bold text-primary text-decoration-none">Đăng nhập</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script>
        (function() {
            'use strict';
            const form = document.getElementById('registerForm');
            const pass = document.getElementById('password');
            const confirmPass = document.getElementById('confirmPassword');
            const confirmFeedback = document.getElementById('confirmPasswordFeedback');

            function validatePasswordMatch() {
                if (pass.value && confirmPass.value) {
                    if (pass.value !== confirmPass.value) {
                        confirmPass.setCustomValidity('Mật khẩu xác nhận không khớp!');
                        confirmFeedback.textContent = 'Mật khẩu xác nhận không khớp với mật khẩu đã nhập!';
                    } else {
                        confirmPass.setCustomValidity('');
                    }
                }
            }

            pass.addEventListener('input', validatePasswordMatch);
            confirmPass.addEventListener('input', validatePasswordMatch);

            form.addEventListener('submit', function(event) {
                validatePasswordMatch();
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
