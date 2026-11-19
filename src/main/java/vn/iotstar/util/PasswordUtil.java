package vn.iotstar.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Tiện ích mã hóa và kiểm tra mật khẩu sử dụng thuật toán BCrypt
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class PasswordUtil {

    /**
     * Băm mật khẩu văn bản thô thành chuỗi BCrypt hash
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return "";
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiểm tra mật khẩu người dùng nhập vào so với chuỗi hash trong CSDL
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            }
            // Hỗ trợ tương thích ngược với mật khẩu chưa hash
            return plainPassword.equals(hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}
