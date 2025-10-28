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
            <a href="login" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <span class="nav-label">Đăng nhập</span>
            </a>
            <a href="register" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a5 5 0 10-5-5 5 5 0 005 5zm7 1h-3v-3h-2v3h-3v2h3v3h2v-3h3zM4 18.25C4 15.9 7.13 14 12 14v2c-3.87 0-6 1.23-6 2.25V20H4z"/></svg>
                </span>
                <span class="nav-label">Đăng ký</span>
            </a>
            <a href="reports" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M5 4h3v16H5zm5 6h3v10h-3zm5-4h3v14h-3z"/></svg>
                </span>
                <span class="nav-label">Thống kê</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card hero-card" aria-labelledby="hero-title">
        <div class="hero-card__content">
            <span class="hero-card__eyebrow">Quản lý tập trung</span>
            <h1 id="hero-title">Hệ thống quản lý siêu thị điện máy gọn gàng & dễ dùng</h1>
            <p>QLST giúp nhân viên nhanh chóng đăng ký khách hàng thân thiết, theo dõi doanh thu theo khoảng thời gian và đi sâu vào từng giao dịch chỉ với vài thao tác.</p>
            <div class="hero-card__actions">
                <a class="btn" href="login">Đăng nhập</a>
                <a class="btn btn-secondary" href="register">Đăng ký tài khoản</a>
            </div>
        </div>
        <div class="hero-card__media" aria-hidden="true">
            <div class="hero-card__glow"></div>
            <div class="hero-card__media-icon">
                <svg viewBox="0 0 64 64" role="presentation">
                    <path d="M12 50V14a4 4 0 014-4h32a4 4 0 014 4v36a4 4 0 01-4 4H16a4 4 0 01-4-4zm12-22h-6v20h6zm12-8h-6v28h6zm12 12h-6v16h6z" opacity="0.7"/>
                    <path d="M20 28h6v20h-6zm12-8h6v28h-6zm12 12h6v16h-6z"/>
                </svg>
            </div>
        </div>
    </section>
    <section class="card module-card" aria-labelledby="module-title">
        <div class="section-header">
            <div>
                <h2 id="module-title">Ba khối chức năng nổi bật</h2>
                <p>Quy trình được thiết kế theo từng bước rõ ràng, giúp đội ngũ vận hành dễ dàng quản lý dữ liệu khách hàng và báo cáo doanh thu.</p>
            </div>
        </div>
        <div class="module-grid">
            <article class="feature-card">
                <span class="feature-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <div>
                    <h3>Đăng ký thành viên</h3>
                    <p>Thu thập thông tin cần thiết của khách hàng và lưu trữ bảo mật để bắt đầu các chương trình ưu đãi.</p>
                </div>
            </article>
            <article class="feature-card">
                <span class="feature-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M4 5h3v14H4zm6 4h3v10h-3zm6-6h3v16h-3z"/></svg>
                </span>
                <div>
                    <h3>Thống kê doanh thu</h3>
                    <p>Chọn nhanh khoảng thời gian để xem doanh thu, số đơn hàng và khách hàng tiêu biểu của siêu thị.</p>
                </div>
            </article>
            <article class="feature-card">
                <span class="feature-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 3a9 9 0 109 9h-2a7 7 0 11-2.05-4.95l-1.4 1.4H21V3l-2.12 2.12A8.96 8.96 0 0012 3zm-1 6h2v5h-2zm0 7h2v2h-2z"/></svg>
                </span>
                <div>
                    <h3>Chi tiết giao dịch riêng</h3>
                    <p>Mỗi khách hàng có trang thống kê độc lập với lịch sử đơn hàng và tổng chi tiêu trực quan.</p>
                </div>
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
