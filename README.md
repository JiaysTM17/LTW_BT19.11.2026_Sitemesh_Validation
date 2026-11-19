# TRƯỜNG ĐẠI HỌC CÔNG NGHỆ KỸ THUẬT THÀNH PHỐ HỒ CHÍ MINH

## KHOA CÔNG NGHỆ THÔNG TIN

### MÔN HỌC: LẬP TRÌNH WEB (WEBPR330479)
**BÀI TẬP THỰC HÀNH - BUỔI HỌC NGÀY 16/11/2026**

---

### THÔNG TIN SINH VIÊN
- **Họ và tên:** Trương Gia Kiệt
- **Mã số sinh viên (MSSV):** 24110032
- **Lớp:** 24110CTNB
- **Môn học:** Lập Trình Web
- **Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung
- **Hệ thống nộp bài:** UTE-LMS (https://utexlms.hcmute.edu.vn)

---

### NỘI DUNG THỰC HIỆN
1. **Kích hoạt tài khoản bằng OTP qua email khi đăng ký tài khoản:**
   - Đăng ký tài khoản mới với trạng thái mặc định `status = 0` (chưa kích hoạt).
   - Tự động sinh mã xác nhận OTP gồm 6 chữ số và gửi qua email đăng ký bằng Jakarta Mail.
   - Nhập đúng OTP để kích hoạt tài khoản (`status = 1`).
2. **Đăng nhập với mật khẩu được mã hóa (hash password) & Đăng xuất:**
   - Mật khẩu người dùng được băm an toàn với giải thuật BCrypt (`org.mindrot:jbcrypt`).
   - Kiểm tra xác thực mật khẩu băm và chỉ cho phép đăng nhập khi tài khoản đã kích hoạt (`status == 1`).
   - Đăng xuất hủy session và xóa cookie ghi nhớ.
3. **Quên mật khẩu gửi mã xác nhận OTP qua email:**
   - Nhập email để nhận mã xác nhận OTP.
   - Xác thực OTP và cập nhật mật khẩu mới (mã hóa BCrypt).
4. **Bảng Videos liên hệ 1 - n với bảng users và các chức năng:**
   - 4.1. Thực hiện đầy đủ CRUD cho bảng Videos (upload file multipart theo slide hướng dẫn `10_UploadFile_servlet_jakarta.pdf`).
   - 4.2. Hiển thị 10 video mới nhất lên trang chủ (`/home`).
   - 4.3. Hiển thị tất cả video của user và phân trang 6sp/trang tại URL `/video`.
   - 4.4. Hiển thị chi tiết và play 01 video khi bấm chuột vào tiêu đề của video đó trên trang chủ `/home` và `/video` (URL `/video/detail?id=...`), tự động tăng lượt xem.
5. **Báo cáo chi tiết:** File Word `BAO_CAO_BAI_TAP_16.11.2026.docx`.

---

### HƯỚNG DẪN CÀI ĐẶT & CHẠY DỰ ÁN
1. Import cơ sở dữ liệu từ file `database.sql` vào MySQL (hoặc SQL Server).
2. Kiểm tra cấu hình kết nối trong file `src/main/resources/META-INF/persistence.xml`.
3. Chạy kiểm thử tự động toàn bộ 7 bài test:
   ```bash
   mvn compile exec:java -Dexec.mainClass="vn.iotstar.config.Test"
   ```
4. Đóng gói file WAR:
   ```bash
   mvn clean package
   ```
5. Deploy file WAR sinh ra trong thư mục `target/24110032_TruongGiaKiet_BT16.11.2026.war` lên Apache Tomcat 10.1+.
