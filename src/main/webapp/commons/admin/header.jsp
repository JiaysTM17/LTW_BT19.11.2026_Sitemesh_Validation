<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-uppercase d-flex align-items-center" href="<c:url value='/admin/videos'/>">
            <i class="fa-solid fa-shield-halved text-warning me-2 fs-5"></i>HCMUTE Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbarContent"
                aria-controls="adminNavbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link text-white" href="<c:url value='/admin/videos'/>">
                        <i class="fa-solid fa-video me-1"></i>Quản lý Video
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="<c:url value='/admin/categories'/>">
                        <i class="fa-solid fa-layer-group me-1"></i>Quản lý Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white-50" href="<c:url value='/home'/>" target="_blank">
                        <i class="fa-solid fa-arrow-up-right-from-square me-1"></i>Xem Trang Người Dùng
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-white d-flex align-items-center" href="#" id="adminUserDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-user-gear fa-lg text-warning me-2"></i>
                                <span class="fw-semibold">${sessionScope.account.fullname != null ? sessionScope.account.fullname : sessionScope.account.username}</span>
                                <span class="badge bg-warning text-dark ms-2">Admin</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="adminUserDropdown">
                                <li>
                                    <span class="dropdown-item-text text-muted small">
                                        <i class="fa-solid fa-envelope me-1"></i>${sessionScope.account.email}
                                    </span>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/profile'/>">
                                        <i class="fa-solid fa-id-card me-2 text-primary"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item text-danger" href="<c:url value='/logout'/>">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm" href="<c:url value='/login'/>">
                                <i class="fa-solid fa-right-to-bracket me-1"></i>Đăng nhập
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
