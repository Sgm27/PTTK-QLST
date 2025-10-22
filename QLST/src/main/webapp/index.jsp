<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>QLST - Giải pháp quản lý siêu thị điện máy</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="landing-body">
<div class="app-shell">
    <header class="app-header">
        <div class="app-header__inner">
            <a class="brand" href="index.jsp" aria-label="Trang chủ QLST">
                <span class="brand__mark">QL</span>
                <span>QLST</span>
            </a>
            <p class="app-tagline">Nền tảng quản lý siêu thị điện máy thống nhất</p>
            <nav class="primary-nav" aria-label="Điều hướng chính">
                <a href="login">Đăng nhập</a>
                <a href="register">Đăng ký</a>
                <a href="dashboard">Bảng điều khiển</a>
                <a href="products">Sản phẩm</a>
                <a href="warehouse">Kho hàng</a>
                <a href="customer">Khách hàng</a>
                <a href="reports">Báo cáo</a>
            </nav>
        </div>
    </header>
    <main class="landing-main">
        <section class="hero" aria-labelledby="hero-title">
            <div>
                <h1 id="hero-title">Quản lý siêu thị điện máy <span class="highlight">toàn diện</span> trên một bảng điều khiển duy nhất</h1>
                <p>QLST tập trung dữ liệu kho, đơn hàng, doanh thu và khách hàng trong một không gian rõ ràng, dễ theo dõi. Mở rộng quy mô mà không cần tăng thêm hệ thống phức tạp.</p>
                <div class="cta-group">
                    <a class="btn btn-primary" href="login">Bắt đầu quản lý</a>
                    <a class="btn btn-secondary" href="register">Mở tài khoản mới</a>
                </div>
            </div>
            <div class="feature-grid" aria-label="Lợi ích nổi bật">
                <article class="feature-card">
                    <h3>Điều hành thống nhất</h3>
                    <p>Quản lý kho, bán hàng và nhân viên trên cùng một luồng công việc cụ thể.</p>
                </article>
                <article class="feature-card">
                    <h3>Theo dõi thời gian thực</h3>
                    <p>Tổng quan doanh thu và tồn kho được cập nhật liên tục để bạn ra quyết định nhanh.</p>
                </article>
                <article class="feature-card">
                    <h3>Phá vỡ tác vụ lặp lại</h3>
                    <p>Tích hợp nhắc việc, duyệt đơn và thông báo cảnh báo tự động.</p>
                </article>
            </div>
        </section>

        <section class="landing-section" aria-labelledby="value-title">
            <div class="section-header">
                <div>
                    <h2 id="value-title">Tại sao doanh nghiệp chọn QLST</h2>
                    <p>Khiến mọi phòng ban làm việc thông minh hơn, từ kế hoạch nhập hàng đến chăm sóc khách hàng trung thành.</p>
                </div>
            </div>
            <div class="feature-grid">
                <article class="feature-card">
                    <h3>Quy trình rõ ràng</h3>
                    <p>Luồng xử lý đơn tinh gọn giúp nhân viên biết rõ việc cần làm ở mỗi bước.</p>
                </article>
                <article class="feature-card">
                    <h3>Phân quyền chi tiết</h3>
                    <p>Mở rộng hệ thống mà không mất kiểm soát, với vai trò rõ ràng cho từng nhóm.</p>
                </article>
                <article class="feature-card">
                    <h3>Báo cáo dễ đọc</h3>
                    <p>Biểu đồ, bảng số liệu và gợi nhắc hạn mức giúp nhìn thấy xu hướng nhanh chóng.</p>
                </article>
                <article class="feature-card">
                    <h3>Hỗ trợ mở rộng</h3>
                    <p>Cấu hình linh hoạt, kết nối sàn thương mại điện tử và các công cụ CRM phổ biến.</p>
                </article>
            </div>
        </section>
    </main>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Giải pháp quản lý siêu thị điện máy hiệu quả</small>
        </div>
    </footer>
</div>
<script src="assets/js/app.js"></script>
</body>
</html>
