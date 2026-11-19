package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.IVideoDao;
import vn.iotstar.dao.impl.VideoDaoImpl;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;

/**
 * Triển khai IVideoService kết nối qua IVideoDao
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class VideoServiceImpl implements IVideoService {

    private final IVideoDao videoDao = new VideoDaoImpl();

    @Override
    public void insert(Video video) {
        videoDao.insert(video);
    }

    @Override
    public void update(Video video) {
        videoDao.update(video);
    }

    @Override
    public void delete(String videoId) throws Exception {
        videoDao.delete(videoId);
    }

    @Override
    public Video findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public List<Video> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video> findAllPaged(int page, int pageSize) {
        return videoDao.findAllPaged(page, pageSize);
    }

    @Override
    public List<Video> findLatest10() {
        return videoDao.findLatest10();
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pageSize) {
        return videoDao.findByUserId(userId, page, pageSize);
    }

    @Override
    public long countByUserId(int userId) {
        return videoDao.countByUserId(userId);
    }

    @Override
    public long count() {
        return videoDao.count();
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        return videoDao.searchByTitle(keyword);
    }

    @Override
    public void increaseViews(String videoId) {
        videoDao.increaseViews(videoId);
    }
}
