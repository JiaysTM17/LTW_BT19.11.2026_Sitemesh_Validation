package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User;

/**
 * Interface IUserService - Định nghĩa nghiệp vụ xác thực người dùng, OTP và phân quyền
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface IUserService {

    User login(String username, String password) throws Exception;

    User register(String username, String password, String email, String fullname, String phone) throws Exception;

    boolean verifyOtp(String email, String otp);

    boolean resendOtp(String email);

    boolean forgotPassword(String emailOrUsername) throws Exception;

    boolean resetPassword(String emailOrUsername, String otp, String newPassword) throws Exception;

    User findById(int id);

    User findByUsername(String username);

    User findByEmail(String email);

    boolean checkExistUsername(String username);

    boolean checkExistEmail(String email);

    boolean checkExistPhone(String phone);

    void update(User user);

    List<User> findAll();
}
