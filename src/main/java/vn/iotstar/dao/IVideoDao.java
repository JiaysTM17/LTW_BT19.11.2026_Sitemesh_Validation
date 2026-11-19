package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Video;

/**
 * Interface IVideoDao - Định nghĩa các thao tác dữ liệu với Entity Video qua JPA
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface IVideoDao {

    void insert(Video video);

    void update(Video video);

    void delete(String videoId) throws Exception;

    Video findById(String videoId);

    List<Video> findAll();

    List<Video> findAllPaged(int page, int pageSize);

    // 10 video mới nhất lên trang chủ
    List<Video> findLatest10();

    // Tất cả video của user có phân trang (6 video/trang)
    List<Video> findByUserId(int userId, int page, int pageSize);

    long countByUserId(int userId);

    long count();

    List<Video> searchByTitle(String keyword);

    // Tăng lượt xem cho video khi người dùng play video
    void increaseViews(String videoId);
}
