<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Trang Chủ - 10 Video Mới Nhất | HCMUTE JPA</title>
    <style>
        .hero-banner { background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%); color: white; padding: 45px 0; margin-bottom: 30px; border-radius: 12px; }
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
    </style>
</head>
<body>
    <!-- Hero Banner -->
    <div class="container">
        <div class="hero-banner shadow-sm text-center">
            <h1 class="display-6 fw-bold mb-2">HỆ THỐNG VIDEO TRỰC TUYẾN JPA 3.0 & SITEMESH 3</h1>
            <p class="lead mb-0 text-light opacity-75 fs-6">Đăng ký xác thực OTP qua Email - Đăng nhập BCrypt - Xem và Play 10 Video mới nhất</p>
        </div>
    </div>

    <!-- Main Content: 10 Video Mới Nhất -->
    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h3 class="fw-bold text-dark mb-0">
                    <i class="fa-solid fa-fire text-danger me-2"></i>10 VIDEO MỚI NHẤT
                </h3>
                <small class="text-muted">Danh sách video mới được cập nhật trên hệ thống</small>
            </div>
            <a href="<c:url value='/video'/>" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                Xem tất cả video <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${empty latestVideos}">
                <div class="alert alert-info text-center py-5 rounded-4 shadow-sm">
                    <i class="fa-solid fa-circle-exclamation fa-3x text-primary mb-3"></i>
                    <h5 class="fw-bold">Hiện chưa có video nào trong hệ thống!</h5>
                    <p class="text-muted mb-3">Vui lòng vào trang quản trị để thêm video mới.</p>
                    <a href="<c:url value='/admin/video/add'/>" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Video Mới
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                    <c:forEach items="${latestVideos}" var="v" varStatus="loop">
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

                                <!-- Card Body -->
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
                                            <i class="fa-solid fa-user-circle me-1 text-primary"></i>${v.user != null ? (not empty v.user.fullname ? v.user.fullname : v.user.username) : 'Quản trị viên'}
                                        </span>
                                        <span class="badge bg-secondary-subtle text-dark">#${loop.index + 1}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
