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
    <section class="card hero-card" aria-labelledby="hero-title">
        <div>
            <h1 id="hero-title">Hệ thống quản lý siêu thị điện máy gọn nhẹ</h1>
            <p>QLST tập trung vào hai nghiệp vụ cốt lõi: khách hàng đăng ký thành viên và quản lý theo dõi doanh thu khách hàng cho nhân viên quản lý.</p>
        </div>
        <div class="cta-group">
            <a class="btn" href="login">Đăng nhập</a>
            <a class="btn btn-secondary" href="register">Đăng ký tài khoản</a>
        </div>
    </section>
    <section class="card module-card" aria-labelledby="module-title">
        <div>
            <h2 id="module-title">Hai chức năng chính</h2>
            <p>Quy trình được tinh giản để người dùng làm chủ thông tin khách hàng nhanh chóng.</p>
        </div>
        <div class="module-grid">
            <article>
                <h3>Đăng ký thành viên</h3>
                <p>Khách hàng điền thông tin cơ bản, hệ thống lưu trữ và bảo mật tài khoản để sử dụng các dịch vụ của siêu thị.</p>
            </article>
            <article>
                <h3>Thống kê doanh thu khách hàng</h3>
                <p>Nhân viên quản lý chọn khoảng thời gian, xem doanh thu, số đơn và chi tiết giao dịch của từng khách hàng.</p>
            </article>
        </div>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Giải pháp theo dõi khách hàng đơn giản</small>
</footer>
<script src="assets/js/app.js"></script>
</body>
</html>
