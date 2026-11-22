package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;

/**
 * Controller quản lý Hồ sơ người dùng (User Profile):
 * 1. Cập nhật thông tin: fullname, phone
 * 2. Upload ảnh đại diện (avatar/images) lên Cloudinary qua Multipart
 * 3. Nếu thay đổi Email mới: hệ thống tự động sinh và gửi mã OTP đến email mới
 *    Người dùng phải xác thực đúng OTP để hoàn tất cập nhật Email.
 * 4. Giao diện được quản lý đồng bộ bởi Sitemesh Decorator Bootstrap 5.
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
@WebServlet(urlPatterns = { "/profile", "/profile/verify-otp" })
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(Constant.SESSION_ACCOUNT) == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        if ("/profile/verify-otp".equals(path)) {
            handleGetVerifyOtp(req, resp, session, currentUser);
        } else {
            handleGetProfile(req, resp, currentUser);
        }
    }

    private void handleGetProfile(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws ServletException, IOException {
        String msg = req.getParameter("msg");
        if ("email_updated_success".equals(msg)) {
            req.setAttribute("successMessage", "Xác thực email mới thành công! Hồ sơ đã được cập nhật hoàn tất.");
        } else if ("profile_updated".equals(msg)) {
            req.setAttribute("successMessage", "Cập nhật thông tin hồ sơ thành công!");
        }

        req.setAttribute("user", currentUser);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    private void handleGetVerifyOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User currentUser)
            throws ServletException, IOException {
        String pendingEmail = (String) session.getAttribute("pendingNewEmail");
        String pendingOtp = (String) session.getAttribute("pendingProfileOtp");

        if (pendingEmail == null || pendingOtp == null) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        String action = req.getParameter("action");
        if ("resend".equalsIgnoreCase(action)) {
            String newOtp = EmailUtil.generateOTP();
            session.setAttribute("pendingProfileOtp", newOtp);
            EmailUtil.sendOtpEmail(pendingEmail, "Mã OTP xác nhận cập nhật Email mới - Web Programming", newOtp);
            req.setAttribute("successMessage", "Đã gửi lại mã OTP đến email: " + pendingEmail);
            pendingOtp = newOtp;
        }

        req.setAttribute("user", currentUser);
        req.setAttribute("newEmail", pendingEmail);
        req.setAttribute("otpCode", pendingOtp);
        req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(Constant.SESSION_ACCOUNT) == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        if ("/profile/verify-otp".equals(path)) {
            handlePostVerifyOtp(req, resp, session, currentUser);
        } else {
            handlePostProfile(req, resp, session, currentUser);
        }
    }

    private void handlePostProfile(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User currentUser)
            throws ServletException, IOException {
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        fullname = fullname != null ? fullname.trim() : "";
        phone = phone != null ? phone.trim() : "";
        email = email != null ? email.trim() : "";

        // Client & Server-side Validation
        if (fullname.isEmpty()) {
            req.setAttribute("errorMessage", "Họ và tên không được để trống!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (fullname.length() < 2) {
            req.setAttribute("errorMessage", "Họ và tên phải có tối thiểu 2 ký tự!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (email.isEmpty()) {
            req.setAttribute("errorMessage", "Địa chỉ email không được để trống!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("errorMessage", "Địa chỉ email không đúng định dạng (ví dụ: user@example.com)!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (!phone.isEmpty() && !phone.matches("^(0|\\+84)[0-9]{9,10}$")) {
            req.setAttribute("errorMessage", "Số điện thoại không hợp lệ (phải gồm 10 số, bắt đầu bằng 0 hoặc +84)!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        // Xử lý upload ảnh đại diện lên Cloudinary bằng multipart
        try {
            Part filePart = req.getPart("image");
            if (filePart == null || filePart.getSize() <= 0) {
                filePart = req.getPart("avatar");
            }
            if (filePart != null && filePart.getSize() > 0) {
                String cloudinaryUrl = CloudinaryUtil.uploadImage(filePart);
                if (cloudinaryUrl != null && !cloudinaryUrl.isEmpty()) {
                    currentUser.setAvatar(cloudinaryUrl);
                }
            }
        } catch (Exception e) {
            System.err.println(">> Lỗi khi đọc file multipart: " + e.getMessage());
        }

        // Cập nhật thông tin cơ bản: fullname, phone, avatar
        currentUser.setFullname(fullname);
        currentUser.setPhone(phone);

        // Kiểm tra xem người dùng có đổi sang email mới hay không
        String currentEmail = currentUser.getEmail() != null ? currentUser.getEmail().trim() : "";
        boolean isEmailChanged = !currentEmail.equalsIgnoreCase(email);

        if (!isEmailChanged) {
            // Không đổi email: Cập nhật ngay vào Database
            try {
                userService.update(currentUser);
                session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);
                resp.sendRedirect(req.getContextPath() + "/profile?msg=profile_updated");
            } catch (Exception e) {
                req.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại: " + e.getMessage());
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            }
        } else {
            // Có đổi email: Kiểm tra trùng lặp email mới với người dùng khác
            User userWithNewEmail = userService.findByEmail(email);
            if (userWithNewEmail != null && userWithNewEmail.getId() != currentUser.getId()) {
                req.setAttribute("errorMessage", "Địa chỉ email '" + email + "' đã tồn tại trong hệ thống. Vui lòng chọn email khác!");
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                return;
            }

            // Lưu tạm các thay đổi khác trước (fullname, phone, avatar)
            try {
                userService.update(currentUser);
                session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);
            } catch (Exception ignored) {
            }

            // Sinh mã OTP 6 số và gửi đến email MỚI
            String otpCode = EmailUtil.generateOTP();
            session.setAttribute("pendingProfileUserId", currentUser.getId());
            session.setAttribute("pendingNewEmail", email);
            session.setAttribute("pendingProfileOtp", otpCode);

            // Gửi OTP đến email mới
            EmailUtil.sendOtpEmail(email, "Mã OTP xác nhận cập nhật Email mới - Web Programming", otpCode);

            // Chuyển hướng sang trang nhập OTP xác thực email mới
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/profile/verify-otp?email=" + encodedEmail + "&msg=otp_sent");
        }
    }

    private void handlePostVerifyOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User currentUser)
            throws ServletException, IOException {
        String enteredOtp = req.getParameter("otp");
        String pendingEmail = (String) session.getAttribute("pendingNewEmail");
        String sessionOtp = (String) session.getAttribute("pendingProfileOtp");

        enteredOtp = enteredOtp != null ? enteredOtp.trim() : "";

        if (pendingEmail == null || sessionOtp == null) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        if (enteredOtp.isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập mã OTP xác thực!");
            req.setAttribute("newEmail", pendingEmail);
            req.setAttribute("user", currentUser);
            req.setAttribute("otpCode", sessionOtp);
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        if (!enteredOtp.equals(sessionOtp)) {
            req.setAttribute("errorMessage", "Mã OTP không chính xác. Vui lòng kiểm tra lại!");
            req.setAttribute("newEmail", pendingEmail);
            req.setAttribute("user", currentUser);
            req.setAttribute("otpCode", sessionOtp);
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        // Xác thực OTP thành công: Cập nhật email mới vào Database
        try {
            currentUser.setEmail(pendingEmail);
            userService.update(currentUser);

            // Cập nhật session với thông tin tài khoản mới nhất
            session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);

            // Xóa session pending
            session.removeAttribute("pendingNewEmail");
            session.removeAttribute("pendingProfileOtp");
            session.removeAttribute("pendingProfileUserId");

            resp.sendRedirect(req.getContextPath() + "/profile?msg=email_updated_success");
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Lỗi cập nhật email: " + e.getMessage());
            req.setAttribute("newEmail", pendingEmail);
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
        }
    }
}
