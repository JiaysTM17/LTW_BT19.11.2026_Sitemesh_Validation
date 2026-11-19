package vn.iotstar.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 * Entity User - Ánh xạ bảng [users] phục vụ xác thực OTP, phân quyền và liên kết Videos
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@Entity
@Table(name = "users")
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "username", length = 50, nullable = false, unique = true)
    private String username;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Column(name = "email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "fullname", columnDefinition = "nvarchar(100)")
    private String fullname;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "avatar", length = 255)
    private String avatar;

    @Column(name = "roleid")
    private int roleid;

    // Trạng thái tài khoản: 0: Chưa kích hoạt OTP, 1: Đã kích hoạt
    @Column(name = "status")
    private int status;

    // Mã OTP kích hoạt tài khoản hoặc đặt lại mật khẩu (6 chữ số)
    @Column(name = "code", length = 10)
    private String code;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createddate")
    private Date createddate;

    // Quan hệ 1 - n: 1 User có nhiều Videos
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Video> videos = new ArrayList<>();

    public User() {
    }

    public User(int id, String username, String password, String email, String fullname, String phone, String avatar,
            int roleid, int status, String code, Date createddate, List<Video> videos) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.phone = phone;
        this.avatar = avatar;
        this.roleid = roleid;
        this.status = status;
        this.code = code;
        this.createddate = createddate;
        this.videos = videos != null ? videos : new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getRoleid() {
        return roleid;
    }

    public void setRoleid(int roleid) {
        this.roleid = roleid;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getCreateddate() {
        return createddate;
    }

    public void setCreateddate(Date createddate) {
        this.createddate = createddate;
    }

    public List<Video> getVideos() {
        return videos;
    }

    public void setVideos(List<Video> videos) {
        this.videos = videos;
    }

    @Override
    public String toString() {
        return "User [id=" + id + ", username=" + username + ", email=" + email + ", fullname=" + fullname
                + ", roleid=" + roleid + ", status=" + status + "]";
    }
}
