<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Quản Lý Video (CRUD JPA) | HCMUTE Admin</title>
    <style>
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .table-hover tbody tr:hover { background-color: #f1f5f9; }
        .img-thumb { width: 110px; height: 70px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container-fluid px-4 py-2">
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header card-header-gradient py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                <div>
                    <h4 class="mb-0"><i class="fa-solid fa-video me-2"></i>QUẢN LÝ VIDEO (CRUD JPA 3.0 & JAKARTA EE)</h4>
                    <small class="text-white-50">Upload Poster ảnh và File Video Multipart theo hướng dẫn Slide</small>
                </div>
                <div class="d-flex gap-2">
                    <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-light btn-sm fw-semibold">
                        <i class="fa-solid fa-layer-group me-1"></i>Quản lý Danh mục
                    </a>
                    <a href="<c:url value='/admin/video/add'/>" class="btn btn-warning btn-sm fw-bold text-dark">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Video Mới
                    </a>
                </div>
            </div>

            <div class="card-body p-4">
                <c:if test="${not empty errorMessage || not empty error}">
                    <div class="alert alert-danger py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i>
                        <div>${not empty errorMessage ? errorMessage : error}</div>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage || not empty message}">
                    <div class="alert alert-success py-2 small d-flex align-items-center mb-3" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i>
                        <div>${not empty successMessage ? successMessage : message}</div>
                    </div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle mb-0">
                        <thead class="table-primary text-center">
                            <tr>
                                <th style="width: 50px;">STT</th>
                                <th style="width: 100px;">Mã Video</th>
                                <th style="width: 120px;">Poster</th>
                                <th>Tiêu Đề Video</th>
                                <th style="width: 130px;">Danh Mục</th>
                                <th style="width: 140px;">Người Đăng</th>
                                <th style="width: 100px;">Lượt Xem</th>
                                <th style="width: 110px;">Trạng Thái</th>
                                <th style="width: 170px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty videoList}">
                                    <tr>
                                        <td colspan="9" class="text-center py-4 text-muted">
                                            Chưa có dữ liệu video trong database. Bấm "Thêm Video Mới" để tạo.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${videoList}" var="v" varStatus="loop">
                                        <tr>
                                            <td class="text-center fw-semibold text-secondary">${loop.index + 1}</td>
                                            <td class="text-center"><span class="badge bg-secondary font-monospace">${v.videoId}</span></td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.poster != null && v.poster.startsWith('http')}">
                                                        <img src="${v.poster}" alt="${v.title}" class="img-thumb">
                                                    </c:when>
                                                    <c:when test="${v.poster != null && !v.poster.isEmpty()}">
                                                        <img src="<c:url value='/image?fname=${v.poster}'/>" alt="${v.title}" class="img-thumb"
                                                             onerror="this.src='https://placehold.co/110x70?text=No+Poster'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://placehold.co/110x70?text=No+Poster" alt="No poster" class="img-thumb">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/video/detail?id=${v.videoId}'/>" target="_blank" class="fw-bold text-dark text-decoration-none">
                                                    ${v.title}
                                                </a>
                                                <div class="small text-muted text-truncate" style="max-width: 300px;">
                                                    ${v.description}
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-info-subtle text-dark">
                                                    ${v.category != null ? v.category.categoryname : 'N/A'}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <small class="fw-semibold">
                                                    ${v.user != null ? (not empty v.user.fullname ? v.user.fullname : v.user.username) : 'Quản trị viên'}
                                                </small>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">
                                                    <i class="fa-solid fa-eye me-1 text-muted"></i>${v.views}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.active == 1}">
                                                        <span class="badge bg-success px-2 py-1"><i class="fa-solid fa-check me-1"></i>Hiển thị</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary px-2 py-1"><i class="fa-solid fa-eye-slash me-1"></i>Ẩn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="<c:url value='/admin/video/edit?id=${v.videoId}'/>" class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>
                                                <a href="<c:url value='/admin/video/delete?id=${v.videoId}'/>" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa video [${v.videoId}] này?');"
                                                   class="btn btn-sm btn-outline-danger" title="Xóa">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                                <a href="<c:url value='/video/detail?id=${v.videoId}'/>" target="_blank" class="btn btn-sm btn-outline-primary ms-1" title="Xem video">
                                                    <i class="fa-solid fa-play"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
