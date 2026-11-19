package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Lớp cấu hình JPA - Quản lý EntityManagerFactory theo mẫu thiết kế Singleton
 * 
 * Dự án: Bài Tập 2 (12/11/2026) - CRUD Category & Video JPA 3.0
 * Sinh viên: Trương Gia Kiệt - MSSV: 24110032
 */
public class JPAConfig {

    private static EntityManagerFactory factory;

    static {
        try {
            // Khởi tạo EntityManagerFactory một lần duy nhất (mặc định MySQL)
            factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
        } catch (Throwable ex) {
            System.err.println(">> Cảnh báo MySQL, thử kết nối SQL Server: " + ex.getMessage());
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-sqlserver");
            } catch (Throwable ex2) {
                System.err.println(">> Lỗi khởi tạo EntityManagerFactory: " + ex2.getMessage());
                ex2.printStackTrace();
            }
        }
    }

    /**
     * Lấy EntityManager mới từ EntityManagerFactory dùng chung
     */
    public static EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
            } catch (Throwable ex) {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-sqlserver");
            }
        }
        return factory.createEntityManager();
    }

    /**
     * Đóng EntityManagerFactory khi tắt ứng dụng
     */
    public static void close() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
