<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Danh Sách Video Của User (Phân Trang) | HCMUTE JPA</title>
    <style>
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
    <div class="container py-2">
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
            <div>
                <span class="badge bg-warning text-dark px-3 py-2 fw-semibold fs-6">
                    <i class="fa-solid fa-calculator me-1"></i>Tổng số: ${totalVideos} Video
                </span>
            </div>
        </div>

        <!-- Danh sách video phân trang (Yêu cầu 4.3: Hiển thị 6 video 1 trang) -->
        <c:choose>
            <c:when test="${empty videoList}">
                <div class="alert alert-info text-center py-5 rounded-4 shadow-sm">
                    <i class="fa-solid fa-box-open fa-3x text-primary mb-3"></i>
                    <h5 class="fw-bold">Chưa có video nào phù hợp!</h5>
                    <p class="text-muted mb-3">Người dùng này chưa đăng tải video nào lên hệ thống.</p>
                    <a href="<c:url value='/home'/>" class="btn btn-outline-primary">
                        <i class="fa-solid fa-house me-1"></i>Quay lại trang chủ
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4 mb-4">
                    <c:forEach items="${videoList}" var="v">
                        <div class="col">
                            <div class="card video-card shadow-sm">
                                <!-- Video Poster with Play Overlay -->
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
                                            <img src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80" alt="Video Poster" class="video-poster-img">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="play-overlay">
                                        <i class="fa-solid fa-circle-play"></i>
                                    </div>
                                </a>

                                <div class="card-body p-3 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="badge bg-primary-subtle text-primary fw-semibold px-2 py-1 rounded">
                                                <i class="fa-solid fa-folder me-1"></i>${v.category != null ? v.category.categoryname : 'Chung'}
                                            </span>
                                            <span class="badge-views">
                                                <i class="fa-solid fa-eye me-1 text-secondary"></i>${v.views}
                                            </span>
                                        </div>
                                        <h6 class="card-title mb-2">
                                            <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="video-title-link" title="${v.title}">
                                                ${v.title}
                                            </a>
                                        </h6>
                                    </div>
                                    <div class="pt-2 border-top mt-2 d-flex justify-content-between align-items-center small text-muted">
                                        <span>
                                            <i class="fa-solid fa-user me-1 text-primary"></i>${v.user != null ? (not empty v.user.fullname ? v.user.fullname : v.user.username) : 'Quản trị viên'}
                                        </span>
                                        <span class="text-secondary small font-monospace">${v.videoId}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Phân trang Pagination (Yêu cầu 4.3: 6 video / trang) -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <!-- Nút Trước -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="<c:url value='/video?userId=${targetUserId}&page=${currentPage - 1}'/>" aria-label="Previous">
                                    <span aria-hidden="true">&laquo; Trước</span>
                                </a>
                            </li>

                            <!-- Các trang số -->
                            <c:forEach begin="1" end="${totalPages}" var="pageIndex">
                                <li class="page-item ${currentPage == pageIndex ? 'active' : ''}">
                                    <a class="page-link" href="<c:url value='/video?userId=${targetUserId}&page=${pageIndex}'/>">${pageIndex}</a>
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
</body>
