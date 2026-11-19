<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản (Kích Hoạt OTP Qua Email) | HCMUTE JPA</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f1f5f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .auth-card { max-width: 500px; margin: 40px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%); color: white; padding: 25px 20px; text-align: center; }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-user-plus fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">ĐĂNG KÝ TÀI KHOẢN</h4>
                <p class="small text-white-50 mb-0">Mã kích hoạt OTP 6 số sẽ được gửi qua Email</p>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${errorMessage}</div>
                    </div>
                </c:if>

                <form action="<c:url value='/register'/>" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-at"></i></span>
                            <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="Ví dụ: kiettg" required autofocus>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email (Nhận mã OTP) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${param.email}" placeholder="example@gmail.com" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-id-card"></i></span>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${param.fullname}" placeholder="Ví dụ: Trương Gia Kiệt">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                            <input type="text" class="form-control" id="phone" name="phone" value="${param.phone}" placeholder="Ví dụ: 0987654321">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Tối thiểu 6 ký tự" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-shield-halved"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
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

    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
