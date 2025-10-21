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
    <div class="wrapper header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span>QL</span>
            Hệ thống QLST
        </a>
        <div class="tagline">Đăng nhập để tiếp tục quản lý siêu thị của bạn</div>
        <nav class="main-nav" aria-label="Điều hướng chính">
            <ul>
                <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">Báo cáo</a></li>
            </ul>
        </nav>
    </div>
</header>
<main>
    <div class="wrapper">
        <section class="form-card" aria-labelledby="login-title">
            <h2 id="login-title">Chào mừng quay trở lại</h2>
            <p class="page-intro">Nhập thông tin đăng nhập để truy cập bảng điều khiển và các công cụ vận hành.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
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
                    <button type="submit" class="btn btn-primary">Đăng nhập</button>
                </div>
            </form>
            <p class="form-note">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="wrapper">
        <small>&copy; 2024 QLST &mdash; Đăng nhập an toàn cho mọi vai trò</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
