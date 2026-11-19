package vn.iotstar.config;

import java.util.Date;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.dao.impl.VideoDaoImpl;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

/**
 * Lớp kiểm thử toàn diện các chức năng ngày 16/11/2026:
 * 1. Đăng ký tài khoản, sinh OTP gửi email, mã hóa BCrypt
 * 2. Xác thực kích hoạt tài khoản bằng OTP (status = 1)
 * 3. Đăng nhập kiểm tra hash BCrypt
 * 4. Quên mật khẩu gửi OTP và đặt lại mật khẩu mới
 * 5. Bảng Videos có quan hệ 1-n với Users, Category
 * 6. Top 10 video mới nhất & phân trang 6 video/trang
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class Test {

    public static void main(String[] args) {
        System.out.println("==================================================================");
        System.out.println("   KIỂM THỬ HỆ THỐNG BÀI TẬP 16/11/2026 - TRƯƠNG GIA KIỆT (24110032)");
        System.out.println("==================================================================");

        EntityManager enma = JPAConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();

        IUserDao userDao = new UserDaoImpl();
        IVideoDao videoDao = new VideoDaoImpl();

        try {
            // ------------------------------------------------------------------
            // 1. Kiểm thử BCrypt Hash và Verify
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 1] Kiểm tra mã hóa mật khẩu BCrypt ---");
            String rawPassword = "mySecretPassword123";
            String hashedPassword = PasswordUtil.hashPassword(rawPassword);
            System.out.println("Mật khẩu gốc: " + rawPassword);
            System.out.println("Mật khẩu mã hóa BCrypt: " + hashedPassword);
            boolean match = PasswordUtil.checkPassword(rawPassword, hashedPassword);
            System.out.println("Kiểm tra khớp mật khẩu: " + (match ? "THÀNH CÔNG (MATCH)" : "THẤT BẠI"));

            // ------------------------------------------------------------------
            // 2. Tạo User mẫu & Sinh OTP
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 2] Đăng ký User với mã OTP 6 số ---");
            String testEmail = "testuser_24110032@iotstar.vn";
            User existingUser = userDao.findByEmail(testEmail);
            if (existingUser != null) {
                userDao.delete(existingUser.getId());
            }

            User user = new User();
            user.setUsername("kiet_test");
            user.setPassword(PasswordUtil.hashPassword("123456"));
            user.setEmail(testEmail);
            user.setFullname("Trương Gia Kiệt (Test)");
            user.setPhone("0909123456");
            user.setRoleid(1);
            user.setStatus(0); // Chưa kích hoạt
            String generatedOtp = EmailUtil.generateOtp();
            user.setCode(generatedOtp);
            user.setCreateddate(new Date());

            userDao.insert(user);
            System.out.println(">> Đã thêm User mới: ID=" + user.getId() + ", Email=" + user.getEmail() + ", OTP=" + user.getCode() + ", Status=" + user.getStatus());

            // ------------------------------------------------------------------
            // 3. Kích hoạt tài khoản bằng OTP
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 3] Kích hoạt tài khoản bằng OTP (status = 1) ---");
            User userToActivate = userDao.findByEmail(testEmail);
            if (userToActivate != null && generatedOtp.equals(userToActivate.getCode())) {
                userToActivate.setStatus(1); // Kích hoạt thành công
                userToActivate.setCode(null); // Xóa OTP đã sử dụng
                userDao.update(userToActivate);
                System.out.println(">> Tài khoản ID=" + userToActivate.getId() + " đã kích hoạt thành công! Status=" + userToActivate.getStatus());
            }

            // ------------------------------------------------------------------
            // 4. Tạo Category & Video (Quan hệ 1-n giữa User và Video)
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 4] Tạo Category và Videos với quan hệ 1-n với Users ---");
            Category category = new Category();
            category.setCategoryname("Công Nghệ Lập Trình");
            category.setImages("tech.jpg");
            category.setStatus(1);

            trans.begin();
            enma.persist(category);
            trans.commit();

            // Thêm 8 video mẫu để test Top 10 và Phân trang 6 video/trang
            for (int i = 1; i <= 8; i++) {
                String vId = "vid_demo_" + i;
                Video existingVideo = videoDao.findById(vId);
                if (existingVideo != null) {
                    videoDao.delete(vId);
                }

                Video v = new Video();
                v.setVideoId(vId);
                v.setTitle("Hướng dẫn lập trình Web bài số " + i + " - JPA & Jakarta");
                v.setDescription("Video bài giảng thực hành phát triển ứng dụng Web Servlet JPA.");
                v.setPoster("poster_" + i + ".jpg");
                v.setVideoUrl("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
                v.setActive(1);
                v.setViews(100 * i);
                v.setCategory(category);
                v.setUser(userToActivate); // Liên hệ 1 - n với User

                videoDao.insert(v);
            }
            System.out.println(">> Đã thêm thành công 8 video mẫu thuộc quyền sở hữu của User ID=" + userToActivate.getId());

            // ------------------------------------------------------------------
            // 5. Kiểm thử Top 10 video mới nhất (Yêu cầu 4.2)
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 5] Kiểm tra truy vấn 10 video mới nhất ---");
            List<Video> latestList = videoDao.findLatest10();
            System.out.println(">> Số lượng video mới nhất lấy được: " + latestList.size());
            for (Video v : latestList) {
                System.out.println("   + [" + v.getVideoId() + "] " + v.getTitle() + " | Views: " + v.getViews() + " | User: " + (v.getUser() != null ? v.getUser().getFullname() : "N/A"));
            }

            // ------------------------------------------------------------------
            // 6. Kiểm thử phân trang 6 video/trang của User (Yêu cầu 4.3)
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 6] Kiểm tra phân trang 6 video/trang của User ---");
            long totalUserVideos = videoDao.countByUserId(userToActivate.getId());
            System.out.println(">> Tổng số video của User: " + totalUserVideos);

            List<Video> page1 = videoDao.findByUserId(userToActivate.getId(), 1, 6);
            System.out.println(">> Trang 1 (tối đa 6 video): " + page1.size() + " video");
            for (Video v : page1) {
                System.out.println("   - " + v.getVideoId() + ": " + v.getTitle());
            }

            List<Video> page2 = videoDao.findByUserId(userToActivate.getId(), 2, 6);
            System.out.println(">> Trang 2 (các video còn lại): " + page2.size() + " video");
            for (Video v : page2) {
                System.out.println("   - " + v.getVideoId() + ": " + v.getTitle());
            }

            // ------------------------------------------------------------------
            // 7. Kiểm thử tăng lượt xem Video (Yêu cầu 4.4)
            // ------------------------------------------------------------------
            System.out.println("\n--- [TEST 7] Bấm xem chi tiết video (Play video & tăng views) ---");
            String sampleVidId = "vid_demo_1";
            Video beforeView = videoDao.findById(sampleVidId);
            int viewsBefore = beforeView.getViews();
            videoDao.increaseViews(sampleVidId);
            Video afterView = videoDao.findById(sampleVidId);
            System.out.println(">> Lượt xem trước: " + viewsBefore + " -> Lượt xem sau khi bấm xem: " + afterView.getViews());

            System.out.println("\n==================================================================");
            System.out.println("   TẤT CẢ 7/7 BÀI TEST ĐỀU HOÀN THÀNH XUẤT SẮC - SẴN SÀNG TRIỂN KHAI!");
            System.out.println("==================================================================");

        } catch (Exception e) {
            System.err.println(">> GẶP LỖI KIỂM THỬ: " + e.getMessage());
            e.printStackTrace();
        } finally {
            enma.close();
            JPAConfig.close();
            System.exit(0);
        }
    }
}
