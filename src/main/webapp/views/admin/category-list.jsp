<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Danh Mục - HCMUTE JPA 3.0</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-gradient { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; }
        .table-hover tbody tr:hover { background-color: #f1f5f9; }
        .img-thumb { width: 120px; height: 90px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header card-header-gradient py-3 d-flex justify-content-between align-items-center">
            <h4 class="mb-0"><i class="fa-solid fa-list-check me-2"></i>QUẢN LÝ DANH MỤC (JPA 3.0 & JAKARTA EE)</h4>
            <a href="<c:url value='/admin/category/add'/>" class="btn btn-light fw-bold text-primary">
                <i class="fa-solid fa-plus me-1"></i>Thêm Danh Mục Mới
            </a>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle mb-0">
                    <thead class="table-primary text-center">
                        <tr>
                            <th style="width: 70px;">STT</th>
                            <th style="width: 150px;">Hình Ảnh</th>
                            <th>Tên Danh Mục</th>
                            <th style="width: 140px;">Trạng Thái</th>
                            <th style="width: 180px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listcate}" var="cate" varStatus="STT">
                            <tr>
                                <td class="text-center fw-semibold text-secondary">${STT.index + 1}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${cate.images != null && cate.images.startsWith('http')}">
                                            <c:url value="${cate.images}" var="imgUrl"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${imgUrl}" class="img-thumb" alt="${cate.categoryname}" 
                                         onerror="this.src='https://placehold.co/120x90?text=No+Image'"/>
                                </td>
                                <td>
                                    <span class="fw-bold text-dark">${cate.categoryname}</span>
                                    <div class="small text-muted">Mã ID: #${cate.categoryid}</div>
                                </td>
                                <td class="text-center">
                                    <c:if test="${cate.status == 1}">
                                        <span class="badge bg-success px-3 py-2"><i class="fa-solid fa-circle-check me-1"></i>Hoạt động</span>
                                    </c:if>
                                    <c:if test="${cate.status != 1}">
                                        <span class="badge bg-danger px-3 py-2"><i class="fa-solid fa-lock me-1"></i>Khóa</span>
                                    </c:if>
                                </td>
                                <td class="text-center">
                                    <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn btn-sm btn-outline-warning me-1">
                                        <i class="fa-solid fa-pen-to-square me-1"></i>Sửa
                                    </a>
                                    <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');"
                                       class="btn btn-sm btn-outline-danger">
                                        <i class="fa-solid fa-trash me-1"></i>Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if empty="${listcate}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">Chưa có danh mục nào trong hệ thống.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
