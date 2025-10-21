<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý kho - QLST</title>
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
        <div class="tagline">Giám sát nhập xuất kho chính xác, hiệu quả</div>
        <nav class="main-nav" aria-label="Điều hướng chính">
            <ul>
                <li><a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">Báo cáo</a></li>
            </ul>
        </nav>
    </div>
</header>
<main>
    <div class="wrapper">
        <section class="section-card">
            <div class="section-header">
                <div>
                    <h2>Quản lý kho</h2>
                    <p>Chuẩn bị các tác vụ nhập hàng, duyệt đơn và xuất hàng với giao diện trực quan, thống nhất.</p>
                </div>
                <div class="status-pill">Phiên bản đang phát triển</div>
            </div>
            <div class="feature-grid">
                <article class="feature-card">
                    <h3>Nhập hàng</h3>
                    <p>Tạo phiếu nhập, ghi nhận số lô, hạn bảo hành và cập nhật tồn kho thời gian thực.</p>
                </article>
                <article class="feature-card">
                    <h3>Duyệt đơn</h3>
                    <p>Đối chiếu đơn online với tồn kho, chọn điểm xuất và gửi thông báo cho đội giao nhận.</p>
                </article>
                <article class="feature-card">
                    <h3>Xuất hàng</h3>
                    <p>In phiếu xuất, cập nhật số seri và xác nhận bàn giao để đồng bộ với hệ thống bán hàng.</p>
                </article>
            </div>
            <p class="page-intro">Chức năng chi tiết sẽ sớm được bổ sung. Vui lòng quay lại sau để sử dụng đầy đủ quy trình kho vận.</p>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="wrapper">
        <small>&copy; 2024 QLST &mdash; Giải pháp quản lý kho hiện đại</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
