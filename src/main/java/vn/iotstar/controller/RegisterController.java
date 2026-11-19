package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

/**
 * Controller xử lý đăng ký tài khoản và gửi mã OTP qua email
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        username = username != null ? username.trim() : "";
        email = email != null ? email.trim() : "";
        fullname = fullname != null ? fullname.trim() : "";
        phone = phone != null ? phone.trim() : "";
        password = password != null ? password.trim() : "";
        confirmPassword = confirmPassword != null ? confirmPassword.trim() : "";

        // Helper để lưu dữ liệu form khi có lỗi
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);

        // 1. Kiểm tra các trường bắt buộc
        if (username.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            String msg = "Vui lòng điền đầy đủ các thông tin bắt buộc (*)!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra định dạng tên đăng nhập
        if (!username.matches("^[a-zA-Z0-9_]{3,30}$")) {
            String msg = "Tên đăng nhập phải từ 3-30 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới (_)!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra định dạng Email
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            String msg = "Địa chỉ email không đúng định dạng (ví dụ: user@example.com)!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 4. Kiểm tra định dạng Số điện thoại (nếu có nhập)
        if (!phone.isEmpty() && !phone.matches("^(0|\\+84)[0-9]{9,10}$")) {
            String msg = "Số điện thoại không hợp lệ (phải gồm 10 số, bắt đầu bằng 0 hoặc +84)!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 5. Kiểm tra độ dài mật khẩu
        if (password.length() < 6) {
            String msg = "Mật khẩu phải có tối thiểu 6 ký tự!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 6. Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            String msg = "Mật khẩu xác nhận không khớp!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // 7. Kiểm tra trùng lặp Username và Email trong DB
        if (userService.checkExistUsername(username)) {
            String msg = "Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email)) {
            String msg = "Địa chỉ email '" + email + "' đã tồn tại trong hệ thống. Vui lòng sử dụng email khác!";
            req.setAttribute("errorMessage", msg);
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        try {
            User registeredUser = userService.register(username, password, email, fullname, phone);
            // Lưu OTP vào Session để hiển thị hỗ trợ kiểm thử tiện lợi trên giao diện
            req.getSession().setAttribute("registeredOtp", registeredUser.getCode());
            req.getSession().setAttribute("registeredEmail", registeredUser.getEmail());

            resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + email + "&msg=otp_sent");
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Đăng ký thất bại. Vui lòng thử lại!";
            req.setAttribute("errorMessage", errorMsg);
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
