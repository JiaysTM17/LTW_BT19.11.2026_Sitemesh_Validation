package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.util.Constant;

/**
 * Controller phục vụ tải và stream file ảnh, video từ thư mục upload
 * Hỗ trợ HTTP Range request (HTTP 206 Partial Content) để phát mượt mà trên trình duyệt HTML5
 * URL: /image?fname=... và /file?fname=...
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = { "/image", "/file" })
public class DownloadImageController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = "demo.mp4";
        }

        File file = new File(Constant.UPLOAD_DIRECTORY + File.separator + fileName);
        if (!file.exists() || !file.isFile()) {
            // Thử tìm trong thư mục assets webapp nếu chưa có ở D:/upload
            String realPath = getServletContext().getRealPath("/assets/" + fileName);
            if (realPath != null) {
                File fallback = new File(realPath);
                if (fallback.exists()) {
                    file = fallback;
                }
            }
            if (!file.exists() || !file.isFile()) {
                // Thử file demo.mp4 mặc định
                File demoFile = new File(Constant.UPLOAD_DIRECTORY + File.separator + "demo.mp4");
                if (demoFile.exists()) {
                    file = demoFile;
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            String lower = file.getName().toLowerCase();
            if (lower.endsWith(".mp4")) {
                mimeType = "video/mp4";
            } else if (lower.endsWith(".webm")) {
                mimeType = "video/webm";
            } else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) {
                mimeType = "image/jpeg";
            } else if (lower.endsWith(".png")) {
                mimeType = "image/png";
            } else if (lower.endsWith(".gif")) {
                mimeType = "image/gif";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        long fileLength = file.length();
        resp.setContentType(mimeType);
        resp.setHeader("Accept-Ranges", "bytes");

        // Xử lý HTTP Range header cho HTML5 Video streaming (seeking & autoplay)
        String rangeHeader = req.getHeader("Range");
        if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
            long start = 0;
            long end = fileLength - 1;

            String[] ranges = rangeHeader.substring(6).split("-");
            try {
                if (ranges.length > 0 && !ranges[0].isEmpty()) {
                    start = Long.parseLong(ranges[0]);
                }
                if (ranges.length > 1 && !ranges[1].isEmpty()) {
                    end = Long.parseLong(ranges[1]);
                }
            } catch (NumberFormatException ignored) {
            }

            if (start > end || start >= fileLength) {
                resp.setStatus(HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                resp.setHeader("Content-Range", "bytes */" + fileLength);
                return;
            }

            if (end >= fileLength) {
                end = fileLength - 1;
            }

            long contentLength = end - start + 1;
            resp.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            resp.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + fileLength);
            resp.setHeader("Content-Length", String.valueOf(contentLength));

            try (FileInputStream inStream = new FileInputStream(file);
                    OutputStream outStream = resp.getOutputStream()) {
                long skipped = inStream.skip(start);
                byte[] buffer = new byte[8192];
                long bytesRemaining = contentLength;
                while (bytesRemaining > 0) {
                    int toRead = (int) Math.min(buffer.length, bytesRemaining);
                    int bytesRead = inStream.read(buffer, 0, toRead);
                    if (bytesRead == -1) {
                        break;
                    }
                    outStream.write(buffer, 0, bytesRead);
                    bytesRemaining -= bytesRead;
                }
                outStream.flush();
            }
        } else {
            // Phục vụ toàn bộ file thông thường
            resp.setContentLengthLong(fileLength);
            try (FileInputStream inStream = new FileInputStream(file);
                    OutputStream outStream = resp.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = inStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
                outStream.flush();
            }
        }
    }
}
