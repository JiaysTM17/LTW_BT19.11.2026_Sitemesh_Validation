<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${video.title} - Xem & Phát Video | HCMUTE JPA</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #0f172a; color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .video-player-container { background-color: #000; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        video { width: 100%; max-height: 600px; display: block; outline: none; }
        .video-meta-box { background-color: #1e293b; border-radius: 14px; padding: 25px; margin-top: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.2); }
        .sidebar-box { background-color: #1e293b; border-radius: 14px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.2); }
        .related-video-item { display: flex; gap: 12px; margin-bottom: 16px; text-decoration: none; color: inherit; transition: opacity 0.2s; }
        .related-video-item:hover { opacity: 0.8; }
        .related-poster { width: 120px; height: 75px; object-fit: cover; border-radius: 8px; flex-shrink: 0; }
        .related-title { font-size: 0.9rem; font-weight: 600; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container py-4">
        <!-- Breadcrumb & Back buttons -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value='/home'/>" class="text-info text-decoration-none"><i class="fa-solid fa-house me-1"></i>Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<c:url value='/video'/>" class="text-info text-decoration-none">Video</a></li>
                <li class="breadcrumb-item active text-light" aria-current="page">${video.title}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <!-- Cột trái: Player phát video & Chi tiết thông tin -->
            <div class="col-lg-8">
                <!-- Video Player Box (Yêu cầu 4.4: Play 01 video khi bấm vào tiêu đề) -->
                <div class="video-player-container">
                    <video id="videoPlayer" controls autoplay style="width: 100%; max-height: 550px; background: #000; display: block; border-radius: 16px;" poster="<c:choose><c:when test='${video.poster != null && video.poster.startsWith(\"http\")}'>${video.poster}</c:when><c:otherwise>${pageContext.request.contextPath}/image?fname=${video.poster}</c:otherwise></c:choose>">
                        <c:if test="${not empty video.videoUrl && !video.videoUrl.startsWith('http')}">
                            <source src="${pageContext.request.contextPath}/file?fname=${video.videoUrl}" type="video/mp4">
                        </c:if>
                        <c:if test="${not empty video.videoUrl && video.videoUrl.startsWith('http')}">
                            <source src="${video.videoUrl}" type="video/mp4">
                        </c:if>
                        <!-- Fallback video cục bộ luôn sẵn sàng phát 100% -->
                        <source src="${pageContext.request.contextPath}/file?fname=demo.mp4" type="video/mp4">
                        <source src="${pageContext.request.contextPath}/assets/demo.mp4" type="video/mp4">
                        <source src="https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4" type="video/mp4">
                        Trình duyệt của bạn không hỗ trợ thẻ phát video HTML5.
                    </video>
                </div>

                <!-- Video Metadata -->
                <div class="video-meta-box">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                        <h3 class="fw-bold mb-0 text-white">${video.title}</h3>
                        <span class="badge bg-danger fs-6 px-3 py-2 rounded-pill">
                            <i class="fa-solid fa-eye me-1"></i>${video.views} lượt xem
                        </span>
                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-3 text-secondary mb-3 pb-3 border-bottom border-secondary">
                        <div>
                            <i class="fa-solid fa-folder me-1 text-primary"></i>Danh mục:
                            <span class="text-white fw-semibold">${video.category != null ? video.category.categoryname : 'Mặc định'}</span>
                        </div>
                        <div>
                            <i class="fa-solid fa-user-circle me-1 text-info"></i>Người đăng:
                            <span class="text-white fw-semibold">${video.user != null ? (not empty video.user.fullname ? video.user.fullname : video.user.username) : 'Quản trị viên'}</span>
                        </div>
                        <div>
                            <i class="fa-solid fa-barcode me-1 text-warning"></i>Mã video:
                            <span class="badge bg-secondary">${video.videoId}</span>
                        </div>
                    </div>

                    <!-- Mô tả Video -->
                    <div>
                        <h6 class="text-uppercase text-light fw-bold mb-2"><i class="fa-solid fa-align-left me-2"></i>Mô tả video</h6>
                        <p class="text-light opacity-75 mb-0" style="white-space: pre-line; line-height: 1.6;">
                            ${not empty video.description ? video.description : 'Chưa có thông tin mô tả chi tiết cho video này.'}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Video liên quan / Top 10 mới nhất -->
            <div class="col-lg-4">
                <div class="sidebar-box">
                    <h5 class="fw-bold mb-3 pb-2 border-bottom border-secondary text-warning">
                        <i class="fa-solid fa-fire me-2"></i>Video Đề Xuất (Top 10)
                    </h5>

                    <c:forEach items="${relatedVideos}" var="rv">
                        <c:if test="${rv.videoId != video.videoId}">
                            <a href="<c:url value='/video/detail?id=${rv.videoId}'/>" class="related-video-item">
                                <c:choose>
                                    <c:when test="${rv.poster != null && rv.poster.startsWith('http')}">
                                        <img src="${rv.poster}" alt="${rv.title}" class="related-poster">
                                    </c:when>
                                    <c:when test="${rv.poster != null && !rv.poster.isEmpty()}">
                                        <img src="<c:url value='/image?fname=${rv.poster}'/>" alt="${rv.title}" class="related-poster"
                                             onerror="this.src='https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300" alt="Poster" class="related-poster">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="related-title text-white mb-1" title="${rv.title}">${rv.title}</div>
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

    <!-- Footer -->
    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
