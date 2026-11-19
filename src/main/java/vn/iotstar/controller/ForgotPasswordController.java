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
 * Controller xử lý chức năng quên mật khẩu và đặt lại mật khẩu với mã xác thực OTP qua email
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = {"/forgot-password", "/reset-password"})
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/reset-password".equals(path)) {
            String email = req.getParameter("email");
            HttpSession session = req.getSession(false);
            String sessionOtp = null;
            if (session != null) {
                sessionOtp = (String) session.getAttribute("resetOtp");
            }
            if (sessionOtp == null && email != null) {
                User u = userService.findByEmail(email);
                if (u != null) {
                    sessionOtp = u.getCode();
                }
            }
            req.setAttribute("email", email);
            req.setAttribute("otpCode", sessionOtp);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();
        if ("/forgot-password".equals(path)) {
            handleForgotPassword(req, resp);
        } else if ("/reset-password".equals(path)) {
            handleResetPassword(req, resp);
        }
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập địa chỉ Email đã đăng ký!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.forgotPassword(email.trim());
            User u = userService.findByEmail(email.trim());
            if (u != null) {
                req.getSession().setAttribute("resetOtp", u.getCode());
                req.getSession().setAttribute("resetEmail", u.getEmail());
            }
            resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + email.trim() + "&msg=otp_sent");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (otp == null || otp.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng điền đầy đủ mã OTP và mật khẩu mới!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            userService.resetPassword(email.trim(), otp.trim(), newPassword.trim());
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("resetOtp");
                session.removeAttribute("resetEmail");
            }
            req.setAttribute("successMessage", "Đổi mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("email", email);
            User u = userService.findByEmail(email);
            if (u != null) {
                req.setAttribute("otpCode", u.getCode());
            }
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        }
    }
}
