<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>QLST - Quản lý sàn thương mại</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="app-shell">
<c:set var="currentPage" value="home"/>
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
        <div class="page-hero__content">
            <p class="page-hero__eyebrow">Hệ sinh thái QLST</p>
            <h1 class="page-hero__title">Bảng điều khiển quản lý bán lẻ chuyên nghiệp</h1>
            <p class="page-hero__subtitle">
                Theo dõi khách hàng, doanh thu và giao dịch trong một giao diện tối giản hai tông màu xanh
                dương - trắng, tối ưu cho tốc độ ra quyết định của đội ngũ vận hành.
            </p>
            <div class="hero-actions">
                <a class="button button--primary" href="${ctx}/login">Đăng nhập ngay</a>
                <a class="button button--ghost" href="${ctx}/register">Tạo tài khoản mới</a>
            </div>
        </div>
        <div class="surface-card surface-card--soft">
            <h2 class="section-title">Sẵn sàng vận hành ngay hôm nay</h2>
            <p class="section-subtitle">QLST cung cấp đầy đủ tiện ích cho cả quản lý và khách hàng trung thành.</p>
            <div class="stats-grid">
                <div class="stat-tile">
                    <span class="stat-tile__label">Trải nghiệm</span>
                    <span class="stat-tile__value">Đơn giản</span>
                </div>
                <div class="stat-tile">
                    <span class="stat-tile__label">Báo cáo</span>
                    <span class="stat-tile__value">Theo thời gian</span>
                </div>
                <div class="stat-tile">
                    <span class="stat-tile__label">Khách hàng</span>
                    <span class="stat-tile__value">360°</span>
                </div>
            </div>
        </div>
    </section>
    <section class="container quick-actions-section">
        <div class="quick-actions-section__intro">
            <h2 class="section-title">Bắt đầu với những thao tác quan trọng</h2>
            <p class="section-subtitle">Chúng tôi gom các bước thường dùng vào những thẻ hành động rõ ràng, mỗi thẻ có nút bấm riêng để bạn truy cập nhanh.</p>
        </div>
        <div class="quick-actions" aria-label="Lối tắt">
            <article class="action-card">
                <span class="action-card__icon" aria-hidden="true">📊</span>
                <div class="action-card__body">
                    <h3 class="action-card__title">Truy cập bảng điều khiển</h3>
                    <p class="section-subtitle">Đăng nhập để xem báo cáo doanh thu theo thời gian thực.</p>
                </div>
                <a class="button button--primary action-card__cta" href="${ctx}/login">Đăng nhập</a>
            </article>
            <article class="action-card">
                <span class="action-card__icon" aria-hidden="true">🧾</span>
                <div class="action-card__body">
                    <h3 class="action-card__title">Tạo tài khoản khách hàng</h3>
                    <p class="section-subtitle">Đăng ký mới với kiểm soát quyền hạn rõ ràng.</p>
                </div>
                <a class="button button--ghost action-card__cta" href="${ctx}/register">Tạo hồ sơ</a>
            </article>
            <article class="action-card">
                <span class="action-card__icon" aria-hidden="true">📈</span>
                <div class="action-card__body">
                    <h3 class="action-card__title">Khám phá thống kê</h3>
                    <p class="section-subtitle">Lọc theo khoảng thời gian, xem thứ hạng doanh thu của từng khách hàng.</p>
                </div>
                <a class="button button--ghost action-card__cta" href="${ctx}/statistics/customers">Xem báo cáo</a>
            </article>
        </div>
    </section>
</main>
<footer class="app-footer">
    <small>&copy; 2024 QLST. Nền tảng quản lý sàn thương mại với thiết kế tối giản hai màu.</small>
    <div class="app-footer__links">
        <a href="${ctx}/login">Đăng nhập</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/register">Đăng ký</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/statistics/customers">Thống kê</a>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
