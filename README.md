# TRƯỜNG ĐẠI HỌC CÔNG NGHỆ KỸ THUẬT THÀNH PHỐ HỒ CHÍ MINH

## KHOA CÔNG NGHỆ THÔNG TIN

### MÔN HỌC: LẬP TRÌNH WEB (WEBPR330479)
**BÀI TẬP THỰC HÀNH - BUỔI HỌC THỨ 5 NGÀY 19/11/2026**

---

### THÔNG TIN SINH VIÊN
- **Họ và tên:** Trương Gia Kiệt
- **Mã số sinh viên (MSSV):** 24110032
- **Lớp:** 24110CTNB
- **Môn học:** Lập Trình Web
- **Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung
- **Hệ thống nộp bài:** UTE-LMS (https://utexlms.hcmute.edu.vn)

---

### NỘI DUNG THỰC HIỆN BÀI TẬP (19/11/2026)

#### 1. Cấu hình Sitemesh Decorator 3 với 01 Template Bootstrap:
- Tích hợp thư viện `sitemesh-webfilter` phiên bản `3.2.2` tương thích Jakarta EE 10 / Servlet 6.0 (`pom.xml`).
- Cấu hình bộ lọc `org.sitemesh.config.ConfigurableSiteMeshFilter` trong `web.xml` ánh xạ `/*`.
- Tạo file cấu hình `WEB-INF/sitemesh3.xml`:
  - Định tuyến layout người dùng `/*` -> `/decorators/web.jsp`.
  - Định tuyến layout quản trị `/admin/*` -> `/decorators/admin.jsp`.
  - Loại trừ trang tĩnh và tài nguyên tải xuống (`/assets/*`, `/image*`, `/file*`, `/api*`).
- Xây dựng giao diện Decorator Template Bootstrap 5 hiện đại:
  - Header, Navbar điều hướng, Content Body nhúng qua `<sitemesh:write property="body"/>`, Footer đồng bộ.
  - Phân tách các khối dùng chung vào thư mục `commons/web/` và `commons/admin/` (`header.jsp`, `footer.jsp`).
  - Tối ưu hóa các JSP nội dung trong thư mục `views/` và `views/admin/` để Sitemesh tự động ráp layout sạch đẹp.

#### 2. Thực hiện Validation cho những chức năng có FORM (Client-side & Server-side):
- **Client-side Validation:**
  - Áp dụng Bootstrap 5 form validation (`needs-validation`, `novalidate`, `invalid-feedback`).
  - Kiểm tra tức thời các ràng buộc HTML5 (`required`, `type="email"`, `minlength`, `pattern`).
  - Kiểm tra khớp mật khẩu xác nhận bằng JavaScript trước khi gửi form.
- **Server-side Validation:**
  - **Form Login:** Kiểm tra bắt buộc nhập, độ dài tối thiểu của username (>= 3) và password (>= 6), thông báo lỗi rõ ràng và giữ lại username.
  - **Form Register:** Kiểm tra đầy đủ thông tin bắt buộc, biểu thức regex email, regex số điện thoại, độ dài mật khẩu (>= 6), kiểm tra xác nhận mật khẩu khớp nhau, kiểm tra trùng lặp tài khoản và email trong cơ sở dữ liệu.
  - **Form Forgot Password & Reset Password:** Kiểm tra định dạng email regex, kiểm tra mã OTP, độ dài mật khẩu mới (>= 6), khớp mật khẩu xác nhận.
  - **Form Insert/Edit Category:** Kiểm tra tên danh mục không rỗng, độ dài tối thiểu 2 ký tự, xử lý an toàn dữ liệu số trạng thái `status` và `categoryid`.
  - **Form Insert/Edit Video:** Kiểm tra mã video (không rỗng, định dạng ký tự hợp lệ, kiểm tra trùng lặp ID khi thêm mới), kiểm tra tiêu đề video, bắt buộc chọn danh mục `categoryId`, giữ lại dữ liệu form khi có lỗi.

---

### HƯỚNG DẪN CÀI ĐẶT & CHẠY DỰ ÁN
1. Import cơ sở dữ liệu từ file `database.sql` vào MySQL.
2. Kiểm tra cấu hình kết nối trong file `src/main/resources/META-INF/persistence.xml`.
3. Đóng gói file WAR:
   ```bash
   mvn clean package -DskipTests
   ```
4. Deploy file WAR sinh ra trong thư mục `target/24110032_TruongGiaKiet_BT19.11.2026.war` lên Apache Tomcat 10.1+.
