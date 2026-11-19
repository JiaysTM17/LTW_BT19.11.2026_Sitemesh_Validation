package vn.iotstar.util;

import java.io.File;

/**
 * Hằng số cấu hình hệ thống
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class Constant {

    public static final String UPLOAD_DIRECTORY = "D:/upload";
    public static final String DEFAULT_FILENAME = "default.png";
    public static final String DEFAULT_POSTER = "default_poster.jpg";

    public static final String SESSION_ACCOUNT = "account";
    public static final String COOKIE_REMEMBER = "username";

    static {
        File dir = new File(UPLOAD_DIRECTORY);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}
