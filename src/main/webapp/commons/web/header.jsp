<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-uppercase" href="<c:url value='/home'/>">
            <i class="fa-solid fa-play-circle text-danger me-2"></i>HCMUTE Video JPA
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/home'/>">
                        <i class="fa-solid fa-house me-1"></i>Trang Chủ (Top 10)
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/video'/>">
                        <i class="fa-solid fa-film me-1"></i>Video Của User
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="adminMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fa-solid fa-gears me-1"></i>Quản Trị (Admin)
                    </a>
                    <ul class="dropdown-menu shadow" aria-labelledby="adminMenu">
                        <li><a class="dropdown-item" href="<c:url value='/admin/videos'/>"><i class="fa-solid fa-video me-2"></i>CRUD Video</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/admin/categories'/>"><i class="fa-solid fa-layer-group me-2"></i>CRUD Danh Mục</a></li>
                    </ul>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center text-white" href="#" id="userMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-circle-user fa-lg text-info me-2"></i>
                                <span class="fw-semibold">${sessionScope.account.fullname != null ? sessionScope.account.fullname : sessionScope.account.username}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userMenu">
                                <li>
                                    <span class="dropdown-item-text text-muted small">
                                        <i class="fa-solid fa-envelope me-1"></i>${sessionScope.account.email}
                                    </span>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<c:url value='/video?userId=${sessionScope.account.id}'/>"><i class="fa-solid fa-photo-film me-2"></i>Video của tôi</a></li>
                                <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-light btn-sm" href="<c:url value='/login'/>">
                                <i class="fa-solid fa-right-to-bracket me-1"></i>Đăng Nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-warning btn-sm fw-bold" href="<c:url value='/register'/>">
                                <i class="fa-solid fa-user-plus me-1"></i>Đăng Ký OTP
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
