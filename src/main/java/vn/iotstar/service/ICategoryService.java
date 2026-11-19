package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Category;

/**
 * Interface ICategoryService - Định nghĩa các nghiệp vụ danh mục
 * 
 * Bài tập 2 (12/11/2026) - HCMUTE
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface ICategoryService {

    void insert(Category category);

    int count();

    List<Category> findAll(int page, int pagesize);

    List<Category> searchByName(String catname);

    List<Category> findAll();

    Category findById(int cateid);

    void delete(int cateid) throws Exception;

    void update(Category category);

    Category findByCategoryname(String name);
}
