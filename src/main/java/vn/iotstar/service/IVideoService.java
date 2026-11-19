package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Video;

/**
 * Interface IVideoService - Định nghĩa nghiệp vụ quản lý Video (CRUD, Top 10, Phân trang)
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface IVideoService {

    void insert(Video video);

    void update(Video video);

    void delete(String videoId) throws Exception;

    Video findById(String videoId);

    List<Video> findAll();

    List<Video> findAllPaged(int page, int pageSize);

    // Hiển thị 10 video mới nhất lên trang chủ
    List<Video> findLatest10();

    // Hiển thị tất cả video của user và được phân trang (6 video/trang)
    List<Video> findByUserId(int userId, int page, int pageSize);

    long countByUserId(int userId);

    long count();

    List<Video> searchByTitle(String keyword);

    // Tăng lượt xem khi bấm xem video
    void increaseViews(String videoId);
}
