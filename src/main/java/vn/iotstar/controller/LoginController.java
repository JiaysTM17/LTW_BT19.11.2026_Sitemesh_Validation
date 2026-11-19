package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

/**
 * Controller xử lý đăng nhập với mật khẩu mã hóa (BCrypt Hash) và ghi nhớ phiên
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getContextPath() != null ? req.getSession(false) : null;
        if (session != null && session.getAttribute(Constant.SESSION_ACCOUNT) != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String msg = req.getParameter("msg");
        if ("activated".equals(msg)) {
            req.setAttribute("success", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
        } else if ("reset_success".equals(msg)) {
            req.setAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
        }

        // Đọc Cookie ghi nhớ đăng nhập nếu có
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (Constant.COOKIE_REMEMBER.equals(cookie.getName())) {
                    req.setAttribute("savedUsername", cookie.getValue());
                    break;
                }
            }
        }

        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            String msg = "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.setAttribute("username", username != null ? username.trim() : "");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (username.trim().length() < 3) {
            String msg = "Tên đăng nhập hoặc email phải có tối thiểu 3 ký tự!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.setAttribute("username", username.trim());
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (password.trim().length() < 6) {
            String msg = "Mật khẩu phải có tối thiểu 6 ký tự!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.setAttribute("username", username.trim());
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userService.login(username.trim(), password.trim());
            HttpSession session = req.getSession(true);
            session.setAttribute(Constant.SESSION_ACCOUNT, user);

            // Xử lý cookie nhớ đăng nhập
            if ("on".equals(remember) || "true".equals(remember)) {
                Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, username.trim());
                cookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
                cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
                resp.addCookie(cookie);
            } else {
                Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, "");
                cookie.setMaxAge(0);
                cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
                resp.addCookie(cookie);
            }

            resp.sendRedirect(req.getContextPath() + "/home");
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin!";
            if (errorMsg.contains("chưa được kích hoạt")) {
                // Điều hướng sang trang kích hoạt OTP
                resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + username.trim() + "&msg=otp_sent");
                return;
            }
            req.setAttribute("errorMessage", errorMsg);
            req.setAttribute("error", errorMsg);
            req.setAttribute("username", username.trim());
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }
}
