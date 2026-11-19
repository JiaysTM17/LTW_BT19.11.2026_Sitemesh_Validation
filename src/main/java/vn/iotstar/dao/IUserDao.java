package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.User;

/**
 * Interface IUserDao - Định nghĩa các thao tác dữ liệu với Entity User qua JPA
 * 
 * Môn học: Lập Trình Web (WEBPR330479)
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public interface IUserDao {

    void insert(User user);

    void update(User user);

    void delete(int userId) throws Exception;

    User findById(int userId);

    User findByUsername(String username);

    User findByEmail(String email);

    boolean checkExistUsername(String username);

    boolean checkExistEmail(String email);

    boolean checkExistPhone(String phone);

    List<User> findAll();
}
