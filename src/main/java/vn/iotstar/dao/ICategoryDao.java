package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Category;

/**
 * Interface ICategoryDao - Định nghĩa các thao tác dữ liệu với Entity Category qua JPA
 * 
 * Bài tập 2 (12/11/2026) - HCMUTE
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface ICategoryDao {

    void insert(Category category);

    int count();

    List<Category> findAll(int page, int pagesize);

    List<Category> searchByName(String catname);

    List<Category> findAll();

    Category findById(int cateid);

    void delete(int cateid) throws Exception;

    void update(Category category);

    Category findByCategoryname(String name) throws Exception;
}
