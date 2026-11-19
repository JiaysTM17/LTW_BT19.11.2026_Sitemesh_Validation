package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

/**
 * Controller xử lý kích hoạt tài khoản bằng mã OTP gửi qua email
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = {"/verify-otp"})
public class VerifyOtpController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String action = req.getParameter("action");

        HttpSession session = req.getSession(false);
        String sessionEmail = null;
        String sessionOtp = null;
        if (session != null) {
            sessionEmail = (String) session.getAttribute("registeredEmail");
            sessionOtp = (String) session.getAttribute("registeredOtp");
        }

        if (email == null || email.trim().isEmpty()) {
            email = sessionEmail;
        }

        if ("resend".equalsIgnoreCase(action) && email != null) {
            try {
                userService.resendOtp(email);
                User u = userService.findByEmail(email);
                if (u != null) {
                    sessionOtp = u.getCode();
                    if (session != null) {
                        session.setAttribute("registeredOtp", sessionOtp);
                    }
                }
                req.setAttribute("successMessage", "Đã tạo và gửi lại mã OTP mới!");
            } catch (Exception e) {
                req.setAttribute("errorMessage", e.getMessage());
            }
        }

        // Lấy OTP từ CSDL nếu chưa có trong session
        if (sessionOtp == null && email != null) {
            User u = userService.findByEmail(email);
            if (u != null && u.getCode() != null) {
                sessionOtp = u.getCode();
            }
        }

        req.setAttribute("email", email);
        req.setAttribute("otpCode", sessionOtp);
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");

        if (otp == null || otp.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập mã OTP gồm 6 chữ số!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        boolean verified = userService.verifyOtp(email, otp.trim());
        if (verified) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("registeredOtp");
                session.removeAttribute("registeredEmail");
            }
            req.setAttribute("successMessage", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("errorMessage", "Mã xác thực OTP không chính xác hoặc đã hết hiệu lực!");
            req.setAttribute("email", email);
            User u = userService.findByEmail(email);
            if (u != null) {
                req.setAttribute("otpCode", u.getCode());
            }
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
