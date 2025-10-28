<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="app-shell">
<c:set var="currentPage" value="login"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<header class="app-header">
    <div class="app-bar">
        <a class="brand" href="${ctx}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span class="brand__text">
                <span class="brand__title">QLST</span>
                <span class="brand__subtitle">Retail Suite</span>
            </span>
        </a>
        <nav class="app-nav" aria-label="Điều hướng chính">
            <a class="app-nav__link${currentPage eq 'home' ? ' is-active' : ''}" href="${ctx}/">Trang chủ</a>
            <a class="app-nav__link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
            <a class="app-nav__link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
            <a class="app-nav__link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/statistics/customers" data-active-root="${ctx}/statistics">Thống kê</a>
        </nav>
    </div>
</header>
<main>
    <section class="container page-hero">
        <div>
            <p class="page-hero__eyebrow">QLST Access</p>
            <h1 class="page-hero__title">Đăng nhập vào bảng điều khiển</h1>
            <p class="page-hero__subtitle">
                Sử dụng thông tin tài khoản để truy cập các báo cáo thống kê doanh thu, quản lý khách hàng và giao dịch.
            </p>
        </div>
        <div class="surface-card form-shell" aria-labelledby="login-heading">
            <div>
                <h2 class="section-title" id="login-heading">Thông tin đăng nhập</h2>
                <p class="section-subtitle">Các trường bắt buộc được đánh dấu rõ ràng và hỗ trợ nhập liệu nhanh chóng.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert" role="status">${message}</div>
            </c:if>

            <form action="${ctx}/login" method="post" class="form-grid" autocomplete="on">
                <div class="form-field">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="${empty username ? '' : username}" required
                           placeholder="Ví dụ: nguyenanh" autofocus>
                </div>
                <div class="form-field">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
                </div>
                <div class="form-actions">
                    <button type="submit" class="button button--primary">Đăng nhập</button>
                </div>
            </form>
            <p class="helper-text">Chưa có tài khoản? <a href="${ctx}/register">Tạo mới ngay</a>.</p>
        </div>
    </section>
</main>
<footer class="app-footer">
    <small>&copy; 2024 QLST. Đăng nhập an toàn, tốc độ.</small>
    <div class="app-footer__links">
        <a href="${ctx}/">Trang chủ</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/statistics/customers">Thống kê</a>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
