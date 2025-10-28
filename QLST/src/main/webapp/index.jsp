<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>QLST - Quản lý siêu thị điện máy</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="index.jsp" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span>QLST</span>
        </a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="login">Đăng nhập</a>
            <a href="register">Đăng ký thành viên</a>
            <a href="reports">Thống kê khách hàng</a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card stack" aria-labelledby="app-title">
        <h1 id="app-title">Bảng điều khiển</h1>
        <div class="action-grid">
            <a class="action-card" href="login">
                <span>Đăng nhập</span>
                <span aria-hidden="true">→</span>
            </a>
            <a class="action-card" href="register">
                <span>Đăng ký thành viên</span>
                <span aria-hidden="true">→</span>
            </a>
            <a class="action-card" href="reports">
                <span>Thống kê khách hàng</span>
                <span aria-hidden="true">→</span>
            </a>
        </div>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST</small>
</footer>
<script src="assets/js/app.js"></script>
</body>
</html>
