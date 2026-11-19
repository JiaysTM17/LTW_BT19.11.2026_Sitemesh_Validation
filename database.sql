-- ==============================================================================
-- BÀI TẬP THỰC HÀNH LẬP TRÌNH WEB (16/11/2026) - JPA 3.0 & JAKARTA EE
-- TRƯỜNG ĐẠI HỌC CÔNG NGHỆ KỸ THUẬT THÀNH PHỐ HỒ CHÍ MINH
-- KHOA CÔNG NGHỆ THÔNG TIN
-- Sinh viên: Trương Gia Kiệt - MSSV: 24110032 - Lớp: 24110CTNB
-- Giảng viên hướng dẫn: ThS. Nguyễn Hữu Trung
-- ==============================================================================

-- 1. TẠO CƠ SỞ DỮ LIỆU (CHO MYSQL)
CREATE DATABASE IF NOT EXISTS servletjpa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE servletjpa;

SET FOREIGN_KEY_CHECKS = 0;

-- 2. TẠO BẢNG USERS (Hỗ trợ xác thực OTP, BCrypt Password)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fullname NVARCHAR(100),
    phone VARCHAR(20),
    avatar VARCHAR(255),
    roleid INT DEFAULT 1,
    status INT DEFAULT 0, -- 0: Chưa kích hoạt, 1: Đã kích hoạt OTP
    code VARCHAR(10),     -- Mã OTP kích hoạt 6 số
    createddate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TẠO BẢNG CATEGORIES
CREATE TABLE IF NOT EXISTS categories (
    CategoryId INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName NVARCHAR(255) NOT NULL,
    Images NVARCHAR(500),
    status INT DEFAULT 1
);

-- 4. TẠO BẢNG VIDEOS (Quan hệ 1 - n với USERS và CATEGORIES)
CREATE TABLE IF NOT EXISTS videos (
    VideoId VARCHAR(50) PRIMARY KEY,
    Title NVARCHAR(500) NOT NULL,
    Description NVARCHAR(1000),
    Poster NVARCHAR(500),
    VideoUrl NVARCHAR(500),
    Views INT DEFAULT 0,
    Active INT DEFAULT 1,
    CategoryId INT,
    userId INT,
    CONSTRAINT fk_video_category FOREIGN KEY (CategoryId) REFERENCES categories(CategoryId) ON DELETE SET NULL,
    CONSTRAINT fk_video_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE SET NULL
);

-- 5. CHÈN DỮ LIỆU MẪU (SEED DATA)
-- Mật khẩu mặc định: '123456' được hash BCrypt: $2a$10$w09y/oE20P3p3cKkY5F/he2yqL5eP8478Lh4aI3q3HjF6KqYyY6yG
INSERT INTO users (username, password, email, fullname, phone, roleid, status, createddate)
VALUES 
('admin', '$2a$10$EIXzaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'admin@iotstar.vn', N'Quản Trị Viên', '0909123456', 2, 1, NOW()),
('kiet24110032', '$2a$10$EIXzaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'kiet@iotstar.vn', N'Trương Gia Kiệt', '0987654321', 1, 1, NOW())
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO categories (CategoryId, CategoryName, Images, status)
VALUES 
(1, N'Lập Trình Web Servlet & JPA', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', 1),
(2, N'Công Nghệ Phần Mềm', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600', 1),
(3, N'Trí Tuệ Nhân Tạo & Data', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', 1)
ON DUPLICATE KEY UPDATE CategoryId=CategoryId;

INSERT INTO videos (VideoId, Title, Description, Poster, VideoUrl, Views, Active, CategoryId, userId)
VALUES 
('vid01', N'Hướng dẫn cài đặt môi trường Hibernate JPA 3.0 và Jakarta 6.0', N'Chi tiết cấu hình persistence.xml và EntityManager trong Eclipse/VS Code.', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 1250, 1, 1, 1),
('vid02', N'Xây dựng chức năng Kích hoạt tài khoản bằng OTP qua Email', N'Tích hợp Jakarta Mail và sinh mã xác thực OTP ngẫu nhiên 6 số.', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 980, 1, 1, 1),
('vid03', N'Bảo mật mật khẩu người dùng với giải thuật BCrypt Hash', N'Mã hóa mật khẩu an toàn chống tấn công Rainbow table và Brute-force.', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 850, 1, 2, 2),
('vid04', N'Xử lý Quên mật khẩu và Đặt lại mật khẩu bằng OTP', N'Xác minh email tồn tại, cấp OTP thời hạn 5 phút và cập nhật password hash.', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 620, 1, 2, 2),
('vid05', N'CRUD Video kết hợp Upload Multipart File theo chuẩn Jakarta', N'Tải lên file video mp4 và poster thumbnail lưu trữ thư mục local D:/upload.', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 1430, 1, 1, 2),
('vid06', N'Kỹ thuật phân trang 6 video/trang với TypedQuery JPA', N'Sử dụng setFirstResult và setMaxResults tối ưu hiệu suất truy vấn CSDL.', 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4', 790, 1, 1, 2),
('vid07', N'Thiết kế giao diện xem chi tiết và phát video chuẩn HTML5 Player', N'Tự động tăng view count khi người dùng truy cập /video/detail?id=...', 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 1100, 1, 1, 2),
('vid08', N'Truy vấn 10 video mới nhất hiển thị trang chủ', N'Sắp xếp theo thứ tự giảm dần và giới hạn maxResults 10 bản ghi.', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4', 920, 1, 2, 2),
('vid09', N'Quản trị danh mục và liên kết ManyToOne với Video', N'Mô hình hóa thực thể Category - Video bằng JPA Annotations.', 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackSeeTheWorld.mp4', 670, 1, 3, 2),
('vid10', N'Deploy ứng dụng Jakarta EE lên Apache Tomcat 10.1', N'Đóng gói file WAR và triển khai ứng dụng thực tế trên Server.', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 1890, 1, 3, 1),
('vid11', N'Tối ưu hóa kết nối JPA và quản lý EntityManagerFactory', N'Thiết kế Singleton Pattern cho JPAConfig đảm bảo Thread-safe.', 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4', 430, 1, 1, 2)
ON DUPLICATE KEY UPDATE VideoId=VideoId;

SET FOREIGN_KEY_CHECKS = 1;
