package vn.iotstar.entity;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;

/**
 * Entity Video - Quản lý thông tin Video
 * Thiết lập mối quan hệ ManyToOne (n - 1) với User (Yêu cầu đề bài 16/11/2026)
 * và quan hệ ManyToOne với Category
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
@Entity
@Table(name = "videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "VideoId", length = 50)
    private String videoId;

    @Column(name = "Active")
    private int active;

    @Column(name = "Description", columnDefinition = "nvarchar(1000) null")
    private String description;

    @Column(name = "Poster", columnDefinition = "nvarchar(500) null")
    private String poster;

    @Column(name = "Title", columnDefinition = "nvarchar(500) not null")
    private String title;

    @Column(name = "Views")
    private int views;

    @Column(name = "VideoUrl", columnDefinition = "nvarchar(500) null")
    private String videoUrl;

    // Quan hệ ManyToOne với Category
    @ManyToOne
    @JoinColumn(name = "CategoryId")
    private Category category;

    // Quan hệ ManyToOne với User (Yêu cầu đề bài 16/11/2026: Videos liên hệ 1 - n với users)
    @ManyToOne
    @JoinColumn(name = "userId")
    private User user;

    public Video() {
    }

    public Video(String videoId, int active, String description, String poster, String title, int views,
            String videoUrl, Category category, User user) {
        this.videoId = videoId;
        this.active = active;
        this.description = description;
        this.poster = poster;
        this.title = title;
        this.views = views;
        this.videoUrl = videoUrl;
        this.category = category;
        this.user = user;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Video [videoId=" + videoId + ", title=" + title + ", views=" + views + ", active=" + active + "]";
    }
}
