<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span>QLST</span>
        </a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="${pageContext.request.contextPath}/login" class="nav-link is-active">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <span class="nav-label">Đăng nhập</span>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a5 5 0 10-5-5 5 5 0 005 5zm7 1h-3v-3h-2v3h-3v2h3v3h2v-3h3zM4 18.25C4 15.9 7.13 14 12 14v2c-3.87 0-6 1.23-6 2.25V20H4z"/></svg>
                </span>
                <span class="nav-label">Đăng ký</span>
            </a>
            <a href="${pageContext.request.contextPath}/reports" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M5 4h3v16H5zm5 6h3v10h-3zm5-4h3v14h-3z"/></svg>
                </span>
                <span class="nav-label">Thống kê</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card form-card" aria-labelledby="login-title">
        <div class="form-card__header">
            <h1 id="login-title">Chào mừng quay lại</h1>
            <p>Đăng nhập để truy cập bảng điều khiển thống kê và quản lý dữ liệu khách hàng.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert" role="status">${message}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="form-grid" autocomplete="on">
            <div>
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" value="${empty username ? '' : username}" required autofocus>
            </div>
            <div>
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">Đăng nhập</button>
                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/register">Tạo tài khoản mới</a>
            </div>
        </form>
        <p class="form-footnote">Quên mật khẩu? Liên hệ quản trị viên để được hỗ trợ cấp lại.</p>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Truy cập an toàn cho nhân viên</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
