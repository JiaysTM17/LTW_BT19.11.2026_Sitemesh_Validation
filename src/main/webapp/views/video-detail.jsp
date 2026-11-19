<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>${video.title} - Xem & Phát Video | HCMUTE JPA</title>
    <style>
        .video-player-container { background-color: #000; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        video { width: 100%; max-height: 600px; display: block; outline: none; }
        .video-meta-box { background-color: #fff; border-radius: 14px; padding: 25px; margin-top: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .sidebar-box { background-color: #fff; border-radius: 14px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .related-video-item { display: flex; gap: 12px; margin-bottom: 16px; text-decoration: none; color: inherit; transition: opacity 0.2s; }
        .related-video-item:hover { opacity: 0.8; }
        .related-poster { width: 120px; height: 75px; object-fit: cover; border-radius: 8px; flex-shrink: 0; }
        .related-title { font-size: 0.9rem; font-weight: 600; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
</head>
<body>
    <div class="container py-2">
        <!-- Breadcrumb & Back buttons -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value='/home'/>" class="text-primary text-decoration-none"><i class="fa-solid fa-house me-1"></i>Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<c:url value='/video'/>" class="text-primary text-decoration-none">Video</a></li>
                <li class="breadcrumb-item active" aria-current="page">${video.title}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <!-- Cột trái: Player phát video & Chi tiết thông tin -->
            <div class="col-lg-8">
                <!-- Video Player Box (Yêu cầu: Play 01 video khi bấm vào tiêu đề) -->
                <div class="video-player-container">
                    <video id="videoPlayer" controls autoplay style="width: 100%; max-height: 550px; background: #000; display: block; border-radius: 16px;" poster="<c:choose><c:when test='${video.poster != null && video.poster.startsWith(\"http\")}'>${video.poster}</c:when><c:otherwise>${pageContext.request.contextPath}/image?fname=${video.poster}</c:otherwise></c:choose>">
                        <c:if test="${not empty video.videoUrl && !video.videoUrl.startsWith('http')}">
                            <source src="${pageContext.request.contextPath}/file?fname=${video.videoUrl}" type="video/mp4">
                        </c:if>
                        <c:if test="${not empty video.videoUrl && video.videoUrl.startsWith('http')}">
                            <source src="${video.videoUrl}" type="video/mp4">
                        </c:if>
                        <!-- Fallback source demo -->
                        <source src="${pageContext.request.contextPath}/assets/demo.mp4" type="video/mp4">
                        Trình duyệt của bạn không hỗ trợ thẻ phát video HTML5.
                    </video>
                </div>

                <!-- Video Metadata -->
                <div class="video-meta-box">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                        <span class="badge bg-primary px-3 py-2 fs-6">
                            <i class="fa-solid fa-layer-group me-1"></i>${video.category != null ? video.category.categoryname : 'Chung'}
                        </span>
                        <div class="text-muted small">
                            <span class="me-3"><i class="fa-solid fa-eye text-primary me-1"></i><strong>${video.views}</strong> lượt xem</span>
                            <span><i class="fa-solid fa-barcode text-secondary me-1"></i>Mã video: <strong>${video.videoId}</strong></span>
                        </div>
                    </div>

                    <h3 class="fw-bold text-dark mb-3">${video.title}</h3>

                    <!-- Tác giả đăng tải -->
                    <div class="d-flex align-items-center p-3 bg-light rounded-3 mb-3">
                        <i class="fa-solid fa-circle-user fa-2x text-primary me-3"></i>
                        <div>
                            <div class="fw-bold text-dark">${video.user != null ? (not empty video.user.fullname ? video.user.fullname : video.user.username) : 'Quản trị viên'}</div>
                            <div class="small text-muted">${video.user != null ? video.user.email : 'admin@hcmute.edu.vn'}</div>
                        </div>
                    </div>

                    <!-- Mô tả chi tiết -->
                    <h6 class="fw-bold text-secondary mb-2"><i class="fa-solid fa-circle-info me-1"></i>Mô tả video:</h6>
                    <p class="text-muted mb-0" style="white-space: pre-line;">
                        ${not empty video.description ? video.description : 'Chưa có mô tả cho video này.'}
                    </p>
                </div>
            </div>

            <!-- Cột phải: Gợi ý các video mới nhất khác -->
            <div class="col-lg-4">
                <div class="sidebar-box">
                    <h5 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fa-solid fa-bolt text-warning me-2"></i>VIDEO KHÁC CÙNG XEM
                    </h5>

                    <c:forEach items="${relatedVideos}" var="rv">
                        <c:if test="${rv.videoId != video.videoId}">
                            <a href="<c:url value='/video/detail?id=${rv.videoId}'/>" class="related-video-item p-2 rounded hover-bg">
                                <c:choose>
                                    <c:when test="${rv.poster != null && rv.poster.startsWith('http')}">
                                        <img src="${rv.poster}" alt="${rv.title}" class="related-poster">
                                    </c:when>
                                    <c:when test="${rv.poster != null && !rv.poster.isEmpty()}">
                                        <img src="<c:url value='/image?fname=${rv.poster}'/>" alt="${rv.title}" class="related-poster"
                                             onerror="this.src='https://placehold.co/120x75?text=Video'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://placehold.co/120x75?text=Video" alt="No poster" class="related-poster">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="related-title text-dark mb-1" title="${rv.title}">${rv.title}</div>
                                    <div class="text-secondary small">
                                        <i class="fa-solid fa-eye me-1"></i>${rv.views} xem
                                    </div>
                                    <div class="text-secondary small">
                                        <i class="fa-solid fa-folder me-1"></i>${rv.category != null ? rv.category.categoryname : ''}
                                    </div>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</body>
