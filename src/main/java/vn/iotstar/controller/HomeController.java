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
 * Controller hiển thị trang chủ và danh sách 10 video mới nhất
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Yêu cầu 4.2: Hiển thị 10 video mới nhất lên trang chủ
        List<Video> latestVideos = videoService.findLatest10();
        req.setAttribute("latestVideos", latestVideos);

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
