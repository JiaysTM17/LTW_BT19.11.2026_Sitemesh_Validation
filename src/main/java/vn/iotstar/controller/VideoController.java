package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

/**
 * Controller hiển thị danh sách video của user và phân trang 6sp/trang
 * URL: /video
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@WebServlet(urlPatterns = { "/video" })
public class VideoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();
    private final IUserService userService = new UserServiceImpl();

    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
        }

        int targetUserId = 0;
        String userIdParam = req.getParameter("userId");

        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                targetUserId = Integer.parseInt(userIdParam.trim());
            } catch (NumberFormatException e) {
                targetUserId = 0;
            }
        } else if (currentUser != null) {
            targetUserId = currentUser.getId();
        } else {
            // Nếu chưa đăng nhập và không truyền param, tìm user đầu tiên có video hoặc user 1
            List<User> userList = userService.findAll();
            if (userList != null && !userList.isEmpty()) {
                targetUserId = userList.get(0).getId();
            }
        }

        // Lấy trang hiện tại (mặc định trang 1)
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        long totalVideos = 0;
        List<Video> videos;
        User targetUser = null;

        if (targetUserId > 0) {
            targetUser = userService.findById(targetUserId);
            totalVideos = videoService.countByUserId(targetUserId);
            videos = videoService.findByUserId(targetUserId, page, PAGE_SIZE);
        } else {
            totalVideos = videoService.count();
            videos = videoService.findAllPaged(page, PAGE_SIZE);
        }

        int totalPages = (int) Math.ceil((double) totalVideos / PAGE_SIZE);
        if (totalPages == 0) {
            totalPages = 1;
        }

        req.setAttribute("targetUser", targetUser);
        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("pageSize", PAGE_SIZE);
        req.setAttribute("targetUserId", targetUserId);

        req.getRequestDispatcher("/views/video-list.jsp").forward(req, resp);
    }
}
