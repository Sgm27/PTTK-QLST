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
            <a href="${pageContext.request.contextPath}/login" class="is-active">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register">Đăng ký thành viên</a>
            <a href="${pageContext.request.contextPath}/reports">Thống kê khách hàng</a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card form-card" aria-labelledby="login-title">
        <div>
            <h1 id="login-title">Chào mừng quay lại</h1>
            <p>Nhập thông tin tài khoản để truy cập phần thống kê doanh thu khách hàng.</p>
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
            </div>
        </form>
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>.</p>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Truy cập an toàn cho nhân viên</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
