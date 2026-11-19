<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu (Xác Nhận OTP Qua Mail) | HCMUTE JPA</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f1f5f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .auth-card { max-width: 460px; margin: 60px auto; border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; }
        .auth-header { background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%); color: white; padding: 30px 20px; text-align: center; }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container">
        <div class="card auth-card">
            <div class="auth-header">
                <i class="fa-solid fa-key fa-2x mb-2"></i>
                <h4 class="fw-bold mb-0">QUÊN MẬT KHẨU</h4>
                <p class="small text-white-50 mb-0">Gửi mã xác nhận OTP qua Email để đặt lại mật khẩu</p>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${errorMessage}</div>
                    </div>
                </c:if>

                <p class="text-muted small mb-4">
                    Vui lòng nhập địa chỉ email đã đăng ký. Hệ thống sẽ gửi một mã xác nhận OTP gồm 6 số để bạn đặt lại mật khẩu mới.
                </p>

                <form action="<c:url value='/forgot-password'/>" method="post">
                    <div class="mb-4">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="example@gmail.com" required autofocus>
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

    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
