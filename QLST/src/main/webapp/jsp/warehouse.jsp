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
<div class="app-shell">
    <header class="app-header">
        <div class="app-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
                <span class="brand__mark">QL</span>
                <span>QLST</span>
            </a>
            <p class="app-tagline">Giám sát nhập xuất kho chính xác, hiệu quả</p>
            <nav class="primary-nav" aria-label="Liên kết nhanh">
                <a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/warehouse" class="is-active">Kho hàng</a>
                <a href="${pageContext.request.contextPath}/customer">Khách hàng</a>
                <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            </nav>
        </div>
    </header>
    <div class="app-body">
        <aside class="app-sidebar" aria-label="Điều hướng quản lý">
            <div>
                <div class="sidebar-title">Quy trình kho</div>
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/warehouse" class="is-current">Tổng quan kho</a>
                    <a href="${pageContext.request.contextPath}/products">Tồn kho theo sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/reports">Theo dõi dự trữ</a>
                    <a href="${pageContext.request.contextPath}/dashboard">Thông báo cảnh báo</a>
                </nav>
            </div>
            <p class="sidebar-note">Tính năng chi tiết sẽ được bổ sung ở các phiên bản tiếp theo.</p>
        </aside>
        <main class="app-content">
            <section class="section-card" aria-labelledby="warehouse-overview">
                <div class="section-header">
                    <div>
                        <h2 id="warehouse-overview">Quản lý kho</h2>
                        <p>Chuẩn bị các tác vụ nhập hàng, duyệt đơn và xuất hàng với giao diện rõ ràng, thống nhất.</p>
                    </div>
                    <div class="status-pill">Phiên bản đang phát triển</div>
                </div>
                <div class="feature-grid" aria-label="Quy trình kho">
                    <article class="feature-card">
                        <h3>Nhập hàng</h3>
                        <p>Tạo phiếu nhập, ghi nhận số seri, hạn bảo hành và cập nhật tồn kho thời gian thực.</p>
                    </article>
                    <article class="feature-card">
                        <h3>Duyệt đơn</h3>
                        <p>Đối chiếu đơn online với tồn kho, chọn điểm xuất và thông báo cho đội giao nhận.</p>
                    </article>
                    <article class="feature-card">
                        <h3>Xuất hàng</h3>
                        <p>In phiếu xuất, cập nhật số seri và xác nhận bàn giao để đồng bộ với hệ thống bán hàng.</p>
                    </article>
                </div>
                <p class="page-intro">Chức năng chi tiết sẽ sớm được bổ sung. Vui lòng quay lại sau để sử dụng đầy đủ quy trình kho vận.</p>
            </section>
        </main>
    </div>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Giải pháp quản lý kho hiện đại</small>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
