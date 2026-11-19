<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Video Của User (Phân Trang 6 Video/Trang) | HCMUTE JPA</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .page-header-box { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; border-radius: 12px; padding: 25px; margin-bottom: 30px; }
        .video-card { transition: transform 0.25s ease, box-shadow 0.25s ease; border: none; border-radius: 12px; overflow: hidden; height: 100%; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.12) !important; }
        .video-poster-box { position: relative; width: 100%; padding-top: 56.25%; background-color: #000; overflow: hidden; }
        .video-poster-img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
        .video-card:hover .video-poster-img { transform: scale(1.05); }
        .play-overlay { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: rgba(255,255,255,0.85); font-size: 2.8rem; pointer-events: none; transition: 0.3s; }
        .video-card:hover .play-overlay { color: #ef4444; transform: translate(-50%, -50%) scale(1.15); }
        .video-title-link { color: #1e293b; font-weight: 700; text-decoration: none; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.4; }
        .video-title-link:hover { color: #2563eb; text-decoration: underline; }
        .badge-views { background-color: #f1f5f9; color: #475569; font-weight: 500; font-size: 0.8rem; border-radius: 6px; padding: 4px 8px; }
        .pagination .page-item.active .page-link { background-color: #2563eb; border-color: #2563eb; }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container py-4">
        <!-- Banner thông tin User & Tiêu đề -->
        <div class="page-header-box shadow-sm d-flex flex-wrap justify-content-between align-items-center">
            <div>
                <h3 class="fw-bold mb-1">
                    <i class="fa-solid fa-film me-2"></i>DANH SÁCH VIDEO CỦA USER
                </h3>
                <p class="mb-0 text-white-50">
                    <c:choose>
                        <c:when test="${not empty targetUser}">
                            Đang xem video của tác giả: <span class="text-warning fw-bold">${targetUser.fullname != null ? targetUser.fullname : targetUser.username}</span> (Email: ${targetUser.email})
                        </c:when>
                        <c:otherwise>
                            Đang hiển thị tất cả video trong hệ thống
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="mt-3 mt-md-0">
                <span class="badge bg-warning text-dark fs-6 px-3 py-2 shadow-sm rounded-pill">
                    <i class="fa-solid fa-video me-1"></i>Tổng số: <strong>${totalVideos}</strong> video (6 video / trang)
                </span>
            </div>
        </div>

        <!-- Yêu cầu 4.3: Hiển thị danh sách video phân trang 6sp/trang -->
        <c:choose>
            <c:when test="${empty videos}">
                <div class="alert alert-warning text-center py-5 rounded-4 shadow-sm">
                    <i class="fa-solid fa-box-open fa-3x text-warning mb-3"></i>
                    <h5 class="fw-bold">Chưa có video nào của người dùng này!</h5>
                    <p class="text-muted">Bạn có thể thêm video mới vào hệ thống thông qua trang quản trị Admin.</p>
                    <a href="<c:url value='/admin/video/add'/>" class="btn btn-primary mt-2">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Video Mới
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Grid 6 video / trang -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-5">
                    <c:forEach items="${videos}" var="v">
                        <div class="col">
                            <div class="card video-card shadow-sm">
                                <!-- Video Poster -->
                                <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="video-poster-box text-decoration-none">
                                    <c:choose>
                                        <c:when test="${v.poster != null && v.poster.startsWith('http')}">
                                            <img src="${v.poster}" alt="${v.title}" class="video-poster-img">
                                        </c:when>
                                        <c:when test="${v.poster != null && !v.poster.isEmpty()}">
                                            <img src="<c:url value='/image?fname=${v.poster}'/>" alt="${v.title}" class="video-poster-img"
                                                 onerror="this.src='https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80" alt="Poster" class="video-poster-img">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="play-overlay">
                                        <i class="fa-solid fa-circle-play"></i>
                                    </div>
                                </a>

                                <!-- Card Body -->
                                <div class="card-body p-3 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="badge bg-primary-subtle text-primary fw-semibold px-2 py-1 rounded">
                                                <i class="fa-solid fa-folder me-1"></i>${v.category != null ? v.category.categoryname : 'Mặc định'}
                                            </span>
                                            <span class="badge-views">
                                                <i class="fa-solid fa-eye me-1 text-secondary"></i>${v.views} lượt xem
                                            </span>
                                        </div>
                                        <h5 class="card-title mb-2">
                                            <!-- Yêu cầu 4.4: Bấm chuột vào tiêu đề để xem chi tiết và play video -->
                                            <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="video-title-link" title="${v.title}">
                                                ${v.title}
                                            </a>
                                        </h5>
                                        <p class="card-text text-muted small" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${v.description != null ? v.description : 'Không có mô tả cho video này.'}
                                        </p>
                                    </div>
                                    <div class="pt-2 border-top mt-2 d-flex justify-content-between align-items-center small text-muted">
                                        <span>
                                            <i class="fa-solid fa-user me-1 text-primary"></i>${v.user != null ? (not empty v.user.fullname ? v.user.fullname : v.user.username) : 'Quản trị'}
                                        </span>
                                        <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="btn btn-sm btn-outline-danger py-0 px-2 rounded-pill">
                                            <i class="fa-solid fa-play me-1"></i>Play
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Phân trang 6 video/trang -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="d-flex justify-content-center">
                        <ul class="pagination shadow-sm">
                            <!-- Nút Trước -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="<c:url value='/video?userId=${targetUserId}&page=${currentPage - 1}'/>" aria-label="Previous">
                                    <span aria-hidden="true">&laquo; Trước</span>
                                </a>
                            </li>

                            <!-- Các trang 1..totalPages -->
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="<c:url value='/video?userId=${targetUserId}&page=${p}'/>">${p}</a>
                                </li>
                            </c:forEach>

                            <!-- Nút Sau -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="<c:url value='/video?userId=${targetUserId}&page=${currentPage + 1}'/>" aria-label="Next">
                                    <span aria-hidden="true">Sau &raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
