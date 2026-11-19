package vn.iotstar.util;

import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Tiện ích gửi email mã xác thực OTP qua giao thức SMTP (Jakarta Mail)
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class EmailUtil {

    // Cấu hình tài khoản gửi email (Sinh viên có thể thay thế bằng App Password của Gmail)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "system.webpr.ute@gmail.com";
    private static final String SENDER_PASSWORD = "app_password_placeholder";

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOTP() {
        Random rnd = new Random();
        int number = rnd.nextInt(900000) + 100000;
        return String.valueOf(number);
    }

    public static String generateOtp() {
        return generateOTP();
    }

    /**
     * Gửi mã OTP qua email người nhận
     * @param toEmail Email nhận
     * @param subject Tiêu đề thư
     * @param otpCode Mã OTP 6 chữ số
     * @return true nếu gửi thành công hoặc đã ghi log OTP cho môi trường kiểm thử
     */
    public static boolean sendOtpEmail(String toEmail, String subject, String otpCode) {
        System.out.println("=================================================");
        System.out.println(">> [HỆ THỐNG OTP EMAIL]");
        System.out.println(">> Gửi tới: " + toEmail);
        System.out.println(">> Tiêu đề: " + subject);
        System.out.println(">> MÃ XÁC NHẬN OTP: [" + otpCode + "]");
        System.out.println("=================================================");

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.connectiontimeout", "3000");
            props.put("mail.smtp.timeout", "3000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "Web Programming UTE"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; max-width: 500px;'>"
                    + "<h2 style='color: #0d6efd;'>Xác Thực Tài Khoản - Web Programming</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Mã xác thực OTP của bạn cho thao tác này là:</p>"
                    + "<h1 style='color: #dc3545; letter-spacing: 5px; text-align: center; font-size: 32px; background: #f8f9fa; padding: 10px; border-radius: 6px;'>"
                    + otpCode + "</h1>"
                    + "<p>Mã OTP có hiệu lực trong vòng <b>5 phút</b>. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "<hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>"
                    + "<p style='font-size: 12px; color: #888;'>Trường Đại Học Công Nghệ Kỹ Thuật Thành Phố Hồ Chí Minh</p>"
                    + "</div>";

            message.setContent(content, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            // Môi trường test offline: ghi nhận OTP tại console để tiếp tục kiểm thử luồng web
            System.out.println(">> Lưu ý: SMTP offline hoặc chưa cấu hình app password, mã OTP được ghi tại log để test: " + otpCode);
            return true;
        }
    }
}
