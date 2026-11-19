package vn.iotstar.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

/**
 * Controller quản lý CRUD Video trong trang Quản trị Admin
 * Hỗ trợ Upload File Multipart cho cả Poster (ảnh) và Video (mp4/media)
 * Tuân thủ theo tài liệu hướng dẫn 10_UploadFile_servlet_jakarta.pdf
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 100, // 100MB
        maxRequestSize = 1024 * 1024 * 150 // 150MB
)
@WebServlet(urlPatterns = { "/admin/videos", "/admin/video/add", "/admin/video/insert", "/admin/video/edit",
        "/admin/video/update", "/admin/video/delete" })
public class VideoCrudController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();
    private final ICategoryService categoryService = new CategoryServiceImpl();
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/admin/videos")) {
            List<Video> videoList = videoService.findAll();
            req.setAttribute("videoList", videoList);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (uri.contains("/admin/video/add")) {
            List<Category> categoryList = categoryService.findAll();
            List<User> userList = userService.findAll();
            req.setAttribute("categoryList", categoryList);
            req.setAttribute("userList", userList);
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (uri.contains("/admin/video/edit")) {
            String videoId = req.getParameter("id");
            Video video = videoService.findById(videoId);
            List<Category> categoryList = categoryService.findAll();
            List<User> userList = userService.findAll();
            req.setAttribute("video", video);
            req.setAttribute("categoryList", categoryList);
            req.setAttribute("userList", userList);
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
        } else if (uri.contains("/admin/video/delete")) {
            String videoId = req.getParameter("id");
            try {
                videoService.delete(videoId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        String uploadPath = Constant.UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (uri.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("posterUrl");
            String videoUrlInput = req.getParameter("videoUrl");
            int active = 1;
            try {
                active = Integer.parseInt(req.getParameter("active"));
            } catch (Exception ignored) {
            }

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(req.getParameter("categoryId"));
            } catch (Exception ignored) {
            }

            int userId = 0;
            try {
                userId = Integer.parseInt(req.getParameter("userId"));
            } catch (Exception ignored) {
            }

            // Nếu không chọn userId, lấy từ session account hiện tại
            if (userId <= 0) {
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute(Constant.SESSION_ACCOUNT) != null) {
                    User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
                    userId = sessionUser.getId();
                }
            }

            Video video = new Video();
            video.setVideoId(videoId);
            video.setTitle(title);
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);

            // Gán category
            if (categoryId > 0) {
                Category category = categoryService.findById(categoryId);
                video.setCategory(category);
            }

            // Gán user tác giả
            if (userId > 0) {
                User author = userService.findById(userId);
                video.setUser(author);
            }

            // Xử lý upload poster ảnh
            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0) {
                    String submittedName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int idx = submittedName.lastIndexOf('.');
                    if (idx > 0) {
                        ext = submittedName.substring(idx);
                    }
                    String savedPosterName = "poster_" + System.currentTimeMillis() + ext;
                    posterPart.write(uploadPath + File.separator + savedPosterName);
                    video.setPoster(savedPosterName);
                } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                    video.setPoster(posterUrl.trim());
                } else {
                    video.setPoster(Constant.DEFAULT_POSTER);
                }
            } catch (Exception e) {
                video.setPoster(Constant.DEFAULT_POSTER);
            }

            // Xử lý upload video file (mp4) hoặc URL
            try {
                Part videoFilePart = req.getPart("videoFile");
                if (videoFilePart != null && videoFilePart.getSize() > 0) {
                    String submittedVideoName = Paths.get(videoFilePart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int idx = submittedVideoName.lastIndexOf('.');
                    if (idx > 0) {
                        ext = submittedVideoName.substring(idx);
                    }
                    String savedVideoFileName = "video_" + System.currentTimeMillis() + ext;
                    videoFilePart.write(uploadPath + File.separator + savedVideoFileName);
                    video.setVideoUrl(savedVideoFileName);
                } else if (videoUrlInput != null && !videoUrlInput.trim().isEmpty()) {
                    video.setVideoUrl(videoUrlInput.trim());
                } else {
                    video.setVideoUrl("demo.mp4");
                }
            } catch (Exception e) {
                video.setVideoUrl("demo.mp4");
            }

            videoService.insert(video);
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (uri.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            Video video = videoService.findById(videoId);
            if (video != null) {
                String oldPoster = video.getPoster();
                String oldVideoUrl = video.getVideoUrl();

                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String posterUrl = req.getParameter("posterUrl");
                String videoUrlInput = req.getParameter("videoUrl");
                int active = 1;
                try {
                    active = Integer.parseInt(req.getParameter("active"));
                } catch (Exception ignored) {
                }

                int categoryId = 0;
                try {
                    categoryId = Integer.parseInt(req.getParameter("categoryId"));
                } catch (Exception ignored) {
                }

                int userId = 0;
                try {
                    userId = Integer.parseInt(req.getParameter("userId"));
                } catch (Exception ignored) {
                }

                video.setTitle(title);
                video.setDescription(description);
                video.setActive(active);

                if (categoryId > 0) {
                    Category category = categoryService.findById(categoryId);
                    video.setCategory(category);
                }

                if (userId > 0) {
                    User author = userService.findById(userId);
                    video.setUser(author);
                }

                // Xử lý upload poster mới
                try {
                    Part posterPart = req.getPart("posterFile");
                    if (posterPart != null && posterPart.getSize() > 0) {
                        if (oldPoster != null && !oldPoster.startsWith("http")) {
                            deletePhysicalFile(uploadPath + File.separator + oldPoster);
                        }
                        String submittedName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                        String ext = "";
                        int idx = submittedName.lastIndexOf('.');
                        if (idx > 0) {
                            ext = submittedName.substring(idx);
                        }
                        String savedPosterName = "poster_" + System.currentTimeMillis() + ext;
                        posterPart.write(uploadPath + File.separator + savedPosterName);
                        video.setPoster(savedPosterName);
                    } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                        video.setPoster(posterUrl.trim());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Xử lý upload file video mới
                try {
                    Part videoFilePart = req.getPart("videoFile");
                    if (videoFilePart != null && videoFilePart.getSize() > 0) {
                        if (oldVideoUrl != null && !oldVideoUrl.startsWith("http")) {
                            deletePhysicalFile(uploadPath + File.separator + oldVideoUrl);
                        }
                        String submittedVideoName = Paths.get(videoFilePart.getSubmittedFileName()).getFileName().toString();
                        String ext = "";
                        int idx = submittedVideoName.lastIndexOf('.');
                        if (idx > 0) {
                            ext = submittedVideoName.substring(idx);
                        }
                        String savedVideoFileName = "video_" + System.currentTimeMillis() + ext;
                        videoFilePart.write(uploadPath + File.separator + savedVideoFileName);
                        video.setVideoUrl(savedVideoFileName);
                    } else if (videoUrlInput != null && !videoUrlInput.trim().isEmpty()) {
                        video.setVideoUrl(videoUrlInput.trim());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                videoService.update(video);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    private void deletePhysicalFile(String fullPath) {
        try {
            Path p = Paths.get(fullPath);
            Files.deleteIfExists(p);
        } catch (Exception ignored) {
        }
    }
}
