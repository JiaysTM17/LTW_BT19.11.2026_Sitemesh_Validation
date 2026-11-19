<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Video (CRUD JPA) | HCMUTE Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .table-hover tbody tr:hover { background-color: #f1f5f9; }
        .img-thumb { width: 110px; height: 70px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container py-4">
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
                                                        <img src="${v.poster}" alt="Poster" class="img-thumb">
                                                    </c:when>
                                                    <c:when test="${v.poster != null && !v.poster.isEmpty()}">
                                                        <img src="<c:url value='/image?fname=${v.poster}'/>" alt="Poster" class="img-thumb"
                                                             onerror="this.src='https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=200'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark">No Image</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="fw-bold text-dark text-decoration-none d-block mb-1">
                                                    ${v.title}
                                                </a>
                                                <small class="text-muted" style="display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">
                                                    ${v.description}
                                                </small>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-info-subtle text-info-emphasis px-2 py-1">
                                                    ${v.category != null ? v.category.categoryname : 'N/A'}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <small class="fw-semibold text-secondary">
                                                    ${v.user != null ? (not empty v.user.fullname ? v.user.fullname : v.user.username) : 'N/A'}
                                                </small>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">
                                                    <i class="fa-solid fa-eye me-1 text-primary"></i>${v.views}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.active == 1}">
                                                        <span class="badge bg-success-subtle text-success px-2 py-1">
                                                            <i class="fa-solid fa-check me-1"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger px-2 py-1">
                                                            <i class="fa-solid fa-lock me-1"></i>Khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="btn btn-outline-info" title="Xem video">
                                                        <i class="fa-solid fa-play"></i>
                                                    </a>
                                                    <a href="<c:url value='/admin/video/edit?id=${v.videoId}'/>" class="btn btn-outline-primary" title="Chỉnh sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>
                                                    <a href="<c:url value='/admin/video/delete?id=${v.videoId}'/>" class="btn btn-outline-danger" title="Xóa"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa video [${v.title}] không?');">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </div>
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

    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
