package vn.iotstar.service.impl;

import java.util.Date;
import java.util.List;

import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

/**
 * Triển khai IUserService xử lý logic đăng ký, đăng nhập hash password, OTP email và quên mật khẩu
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class UserServiceImpl implements IUserService {

    private final IUserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) throws Exception {
        User user = userDao.findByUsername(username);
        if (user == null) {
            // Thử tìm theo email nếu người dùng nhập email vào ô đăng nhập
            user = userDao.findByEmail(username);
        }
        if (user == null) {
            throw new Exception("Tài khoản không tồn tại trên hệ thống!");
        }

        // Kiểm tra mật khẩu mã hóa BCrypt
        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            throw new Exception("Mật khẩu không chính xác!");
        }

        // Kiểm tra tài khoản đã kích hoạt OTP chưa
        if (user.getStatus() != 1) {
            throw new Exception("Tài khoản chưa được kích hoạt qua mã OTP email! Vui lòng xác thực tài khoản.");
        }

        return user;
    }

    @Override
    public User register(String username, String password, String email, String fullname, String phone) throws Exception {
        if (userDao.checkExistUsername(username)) {
            throw new Exception("Tên đăng nhập đã tồn tại!");
        }
        if (userDao.checkExistEmail(email)) {
            throw new Exception("Email đã được đăng ký cho tài khoản khác!");
        }

        // Mã hóa mật khẩu an toàn với BCrypt
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Sinh mã OTP 6 chữ số
        String otp = EmailUtil.generateOTP();

        User user = new User();
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setEmail(email);
        user.setFullname(fullname);
        user.setPhone(phone);
        user.setRoleid(2); // Mặc định role là User
        user.setStatus(0); // Chưa kích hoạt
        user.setCode(otp); // Lưu mã OTP kích hoạt
        user.setCreateddate(new Date());

        userDao.insert(user);

        // Gửi email xác thực tài khoản
        EmailUtil.sendOtpEmail(email, "Mã kích hoạt tài khoản - Web Programming", otp);

        return user;
    }

    @Override
    public boolean verifyOtp(String email, String otp) {
        if (email == null || otp == null) {
            return false;
        }
        User user = userDao.findByEmail(email);
        if (user == null) {
            user = userDao.findByUsername(email);
        }
        if (user != null && otp.trim().equals(user.getCode())) {
            user.setStatus(1); // Kích hoạt tài khoản
            user.setCode(null); // Xóa mã OTP sau khi xác thực thành công
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean resendOtp(String email) {
        User user = userDao.findByEmail(email);
        if (user == null) {
            user = userDao.findByUsername(email);
        }
        if (user != null) {
            String newOtp = EmailUtil.generateOTP();
            user.setCode(newOtp);
            userDao.update(user);
            EmailUtil.sendOtpEmail(user.getEmail(), "Gửi lại mã OTP kích hoạt - Web Programming", newOtp);
            return true;
        }
        return false;
    }

    @Override
    public boolean forgotPassword(String emailOrUsername) throws Exception {
        User user = userDao.findByEmail(emailOrUsername);
        if (user == null) {
            user = userDao.findByUsername(emailOrUsername);
        }
        if (user == null) {
            throw new Exception("Không tìm thấy tài khoản với thông tin đã cung cấp!");
        }

        // Tạo mã OTP đặt lại mật khẩu
        String otp = EmailUtil.generateOTP();
        user.setCode(otp);
        userDao.update(user);

        EmailUtil.sendOtpEmail(user.getEmail(), "Mã xác thực đặt lại mật khẩu - Web Programming", otp);
        return true;
    }

    @Override
    public boolean resetPassword(String emailOrUsername, String otp, String newPassword) throws Exception {
        User user = userDao.findByEmail(emailOrUsername);
        if (user == null) {
            user = userDao.findByUsername(emailOrUsername);
        }
        if (user == null) {
            throw new Exception("Tài khoản không tồn tại!");
        }

        if (user.getCode() == null || !user.getCode().equals(otp.trim())) {
            throw new Exception("Mã OTP không chính xác hoặc đã hết hiệu lực!");
        }

        // Mã hóa mật khẩu mới
        user.setPassword(PasswordUtil.hashPassword(newPassword));
        user.setCode(null); // Xóa OTP
        userDao.update(user);
        return true;
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public List<User> findAll() {
        return userDao.findAll();
    }
}
