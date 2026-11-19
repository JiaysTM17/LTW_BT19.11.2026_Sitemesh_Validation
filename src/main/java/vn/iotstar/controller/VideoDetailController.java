package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

/**
 * Controller xem chi tiết và phát video (Play video)
 * Tự động tăng lượt xem khi người dùng truy cập xem video
 * URL: /video/detail?id=...
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = { "/video/detail" })
public class VideoDetailController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Tăng lượt xem (view count)
        videoService.increaseViews(videoId.trim());

        // Lấy thông tin video chi tiết
        Video video = videoService.findById(videoId.trim());
        if (video == null) {
            req.setAttribute("errorMessage", "Không tìm thấy video với mã ID: " + videoId);
            req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
            return;
        }

        // Lấy thêm danh sách video mới nhất gợi ý ở thanh bên
        List<Video> relatedVideos = videoService.findLatest10();

        req.setAttribute("video", video);
        req.setAttribute("relatedVideos", relatedVideos);
        req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
    }
}
