package vn.iotstar.util;

import java.io.File;

/**
 * Hằng số cấu hình hệ thống
 */
public class constants {
    // Thư mục lưu trữ hình ảnh upload
    public static final String DIR = "D:/upload";

    static {
        File dir = new File(DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}
