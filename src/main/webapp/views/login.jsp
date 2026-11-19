<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Đăng Nhập Tài Khoản | HCMUTE JPA</title>
    <style>
        .auth-card { max-width: 450px; margin: 30px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%); color: white; padding: 30px 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-lock fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">ĐĂNG NHẬP HỆ THỐNG</h4>
                <p class="small text-white-50 mb-0">Mật khẩu được mã hóa an toàn với BCrypt</p>
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

                <form action="<c:url value='/login'/>" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label fw-semibold">Tên đăng nhập hoặc Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                            <input type="text" class="form-control" id="username" name="username" value="${username}" placeholder="Nhập username hoặc email" required autofocus>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <label for="password" class="form-label fw-semibold mb-0">Mật khẩu</label>
                            <a href="<c:url value='/forgot-password'/>" class="small text-decoration-none">Quên mật khẩu?</a>
                        </div>
                        <div class="input-group mt-1">
                            <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                        </div>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember" ${remember ? 'checked' : ''}>
                        <label class="form-check-label small" for="remember">Ghi nhớ đăng nhập</label>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-right-to-bracket me-1"></i>Đăng Nhập
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <p class="small text-muted mb-0">Chưa có tài khoản? 
                        <a href="<c:url value='/register'/>" class="fw-bold text-primary text-decoration-none">Đăng ký ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
