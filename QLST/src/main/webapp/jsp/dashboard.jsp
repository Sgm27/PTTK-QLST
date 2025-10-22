<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - QLST</title>
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
            <p class="app-tagline">Tổng quan vận hành được cập nhật liên tục</p>
            <nav class="primary-nav" aria-label="Liên kết nhanh">
                <a href="${pageContext.request.contextPath}/dashboard" class="is-active">Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a>
                <a href="${pageContext.request.contextPath}/customer">Khách hàng</a>
                <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            </nav>
        </div>
    </header>
    <div class="app-body">
        <aside class="app-sidebar" aria-label="Điều hướng quản lý">
            <div>
                <div class="sidebar-title">Khu vực quản lý</div>
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard" class="is-current">Bảng điều khiển</a>
                    <a href="${pageContext.request.contextPath}/products">Danh mục sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a>
                    <a href="${pageContext.request.contextPath}/customer">Thống kê khách hàng</a>
                    <a href="${pageContext.request.contextPath}/reports">Báo cáo doanh thu</a>
                </nav>
            </div>
            <p class="sidebar-note">Dữ liệu tổng hợp từ POS, kho và CRM được đồng bộ 5 phút một lần.</p>
        </aside>
        <main class="app-content">
            <section class="section-card" aria-labelledby="dashboard-intro">
                <div class="section-header">
                    <div>
                        <h2 id="dashboard-intro">Bảng điều khiển quản lý</h2>
                        <p>Theo dõi các chỉ số chính và truy cập nhanh đến các tác vụ quan trọng.</p>
                    </div>
                    <div class="cta-group">
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/products">Quản lý sản phẩm</a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/reports">Xem báo cáo</a>
                    </div>
                </div>
                <div class="stat-grid" aria-label="Số liệu tổng hợp">
                    <article class="stat-card">
                        <h3>Tổng doanh thu</h3>
                        <p>${totalRevenue}</p>
                    </article>
                    <article class="stat-card">
                        <h3>Đơn hàng đã xử lý</h3>
                        <p>${ordersCount}</p>
                    </article>
                    <c:if test="${not empty recentOrders}">
                        <article class="stat-card">
                            <h3>Đơn gần nhất</h3>
                            <p>#${recentOrders[0].id}</p>
                        </article>
                    </c:if>
                </div>
                <p class="page-intro">Số liệu được quét theo thời gian thực giúp bạn thấy rõ sức mua và tình hình tồn kho.</p>
            </section>

            <c:if test="${not empty ordersByStatus}">
                <section class="section-card" aria-labelledby="order-status">
                    <div class="section-header">
                        <div>
                            <h3 id="order-status">Đơn hàng theo trạng thái</h3>
                            <p>Nắm bắt nhanh luồng công việc của nhân viên bán hàng và kho.</p>
                        </div>
                    </div>
                    <ul>
                        <c:forEach var="entry" items="${ordersByStatus}">
                            <li><strong>${entry.key}</strong>: ${entry.value}</li>
                        </c:forEach>
                    </ul>
                </section>
            </c:if>

            <section class="section-card" aria-label="Lối tác vụ nhanh">
                <div class="section-header">
                    <div>
                        <h3>Điều hướng nhanh</h3>
                        <p>Truy cập trực tiếp đến các nhóm công việc phổ biến.</p>
                    </div>
                </div>
                <div class="feature-grid">
                    <a class="feature-card" href="${pageContext.request.contextPath}/warehouse">
                        <h3>Quản lý kho</h3>
                        <p>Cập nhật nhập xuất và kiểm tra tồn theo khu vực.</p>
                    </a>
                    <a class="feature-card" href="${pageContext.request.contextPath}/products">
                        <h3>Danh mục sản phẩm</h3>
                        <p>Cập nhật thông tin sản phẩm và theo dõi nguồn cung.</p>
                    </a>
                    <a class="feature-card" href="${pageContext.request.contextPath}/reports">
                        <h3>Báo cáo doanh thu</h3>
                        <p>Theo dõi số liệu doanh thu và chi phí theo thời gian.</p>
                    </a>
                </div>
            </section>

            <c:if test="${not empty recentOrders}">
                <section class="section-card" aria-labelledby="recent-orders">
                    <div class="section-header">
                        <div>
                            <h3 id="recent-orders">Đơn hàng gần đây</h3>
                            <p>Theo dõi các giao dịch vừa được hoàn tất.</p>
                        </div>
                    </div>
                    <div class="table-card">
                        <div class="table-responsive">
                            <table aria-label="Đơn hàng gần đây">
                                <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Khách hàng</th>
                                    <th scope="col">Ngày đặt</th>
                                    <th scope="col">Trạng thái</th>
                                    <th scope="col">Tổng tiền</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr>
                                        <td>${order.id}</td>
                                        <td>${order.customerId}</td>
                                        <td><c:out value="${order.orderDate}"/></td>
                                        <td>${order.status}</td>
                                        <td>${order.totalAmount}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </c:if>
        </main>
    </div>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Tất cả dữ liệu vận hành trong tầm tay bạn</small>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
