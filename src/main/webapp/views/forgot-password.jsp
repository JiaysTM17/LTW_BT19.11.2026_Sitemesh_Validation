<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Quên Mật Khẩu (Xác Nhận OTP) | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 460px; margin: 40px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%); color: white; padding: 30px 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-key fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">QUÊN MẬT KHẨU</h4>
                <p class="small text-white-50 mb-0">Gửi mã xác nhận OTP qua Email để đặt lại mật khẩu</p>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>

                <p class="text-muted small mb-4">
                    Vui lòng nhập địa chỉ email đã đăng ký. Hệ thống sẽ gửi một mã xác nhận OTP gồm 6 số để bạn đặt lại mật khẩu mới.
                </p>

                <form action="<c:url value='/forgot-password'/>" method="post" class="needs-validation" novalidate>
                    <div class="mb-4">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="example@gmail.com" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" required autofocus>
                            <div class="invalid-feedback">
                                Vui lòng nhập địa chỉ email hợp lệ (ví dụ: user@example.com).
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-warning text-dark w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-paper-plane me-1"></i>Gửi Mã OTP Xác Nhận
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <p class="small text-muted mb-0">Nhớ lại mật khẩu? 
                        <a href="<c:url value='/login'/>" class="fw-bold text-primary text-decoration-none">Quay lại Đăng nhập</a>
                    </p>
                </div>
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
