package vn.iotstar.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Map;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;

/**
 * Tiện ích Upload file đa phương tiện (Multipart) lên Cloudinary
 * Tích hợp Cloudinary SDK hỗ trợ lưu trữ hình ảnh trên đám mây
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class CloudinaryUtil {

    // Cấu hình tài khoản Cloudinary
    public static final String CLOUD_NAME = "dtu5hyk9o";
    public static final String API_KEY = "388421453472477";
    public static final String API_SECRET = "j9zT5wS2Y6XvXq3z9Hq9kK0kZ_M";

    private static Cloudinary cloudinary;

    static {
        try {
            String cloudName = System.getenv("CLOUDINARY_CLOUD_NAME") != null ? System.getenv("CLOUDINARY_CLOUD_NAME") : CLOUD_NAME;
            String apiKey = System.getenv("CLOUDINARY_API_KEY") != null ? System.getenv("CLOUDINARY_API_KEY") : API_KEY;
            String apiSecret = System.getenv("CLOUDINARY_API_SECRET") != null ? System.getenv("CLOUDINARY_API_SECRET") : API_SECRET;

            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
            ));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }

    /**
     * Upload Part multipart từ HttpServletRequest lên Cloudinary
     * 
     * @param part Part file được submit từ form multipart/form-data
     * @return secure_url trả về từ Cloudinary, hoặc fallback file name nếu có lỗi ngoại lệ
     */
    public static String uploadImage(Part part) {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        File tempFile = null;
        try {
            String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String ext = ".png";
            int idx = submittedFileName.lastIndexOf('.');
            if (idx > 0) {
                ext = submittedFileName.substring(idx);
            }

            // Tạo file tạm thời để upload
            tempFile = File.createTempFile("cloudinary_upload_", ext);
            try (InputStream in = part.getInputStream(); FileOutputStream out = new FileOutputStream(tempFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

            // Upload lên Cloudinary
            if (cloudinary != null) {
                @SuppressWarnings("rawtypes")
                Map uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.asMap(
                    "folder", "avatars",
                    "resource_type", "image"
                ));
                if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                    return (String) uploadResult.get("secure_url");
                } else if (uploadResult != null && uploadResult.containsKey("url")) {
                    return (String) uploadResult.get("url");
                }
            }
        } catch (Exception e) {
            System.err.println(">> Lỗi upload Cloudinary: " + e.getMessage() + ". Tiến hành fallback lưu cục bộ.");
            // Fallback lưu cục bộ nếu Cloudinary gặp lỗi mạng hoặc credential offline
            try {
                String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = ".png";
                int idx = submittedName.lastIndexOf('.');
                if (idx > 0) {
                    ext = submittedName.substring(idx);
                }
                String fallbackFileName = "avatar_" + System.currentTimeMillis() + ext;
                String uploadDir = Constant.UPLOAD_DIRECTORY;
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                part.write(uploadDir + File.separator + fallbackFileName);
                return fallbackFileName;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
        return null;
    }
}
