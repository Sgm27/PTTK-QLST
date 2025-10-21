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
<header class="site-header">
    <div class="wrapper header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span>QL</span>
            Hệ thống QLST
        </a>
        <div class="tagline">Toàn cảnh vận hành: doanh thu, đơn hàng và tồn kho</div>
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
                    <h2>Bảng điều khiển quản lý</h2>
                    <p>Theo dõi các chỉ số cốt lõi và truy cập nhanh tới những khu vực quan trọng của hệ thống.</p>
                </div>
                <div class="cta-group">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/products">Quản lý sản phẩm</a>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/reports">Xem báo cáo</a>
                </div>
            </div>
            <div class="stat-grid">
                <article class="stat-card">
                    <h3>Tổng doanh thu</h3>
                    <p>${totalRevenue}</p>
                </article>
                <article class="stat-card">
                    <h3>Tổng số đơn hàng</h3>
                    <p>${ordersCount}</p>
                </article>
                <c:if test="${not empty recentOrders}">
                    <article class="stat-card">
                        <h3>Đơn gần nhất</h3>
                        <p>#${recentOrders[0].id}</p>
                    </article>
                </c:if>
            </div>
            <p class="page-intro">Số liệu được cập nhật liên tục từ kho, bán hàng và hệ thống báo cáo.</p>
        </section>

        <c:if test="${not empty ordersByStatus}">
            <section class="section-card">
                <h3>Đơn hàng theo trạng thái</h3>
                <ul>
                    <c:forEach var="entry" items="${ordersByStatus}">
                        <li><strong>${entry.key}</strong>: ${entry.value}</li>
                    </c:forEach>
                </ul>
            </section>
        </c:if>

        <section class="section-card">
            <h3>Điều hướng nhanh</h3>
            <div class="feature-grid">
                <a class="feature-card" href="${pageContext.request.contextPath}/warehouse">
                    <h3>Quản lý kho</h3>
                    <p>Cập nhật nhập xuất hàng hóa, kiểm kê định kỳ và kiểm tra tồn kho theo khu vực.</p>
                </a>
                <a class="feature-card" href="${pageContext.request.contextPath}/products">
                    <h3>Danh mục sản phẩm</h3>
                    <p>Thêm, chỉnh sửa và theo dõi sản phẩm theo nhà cung cấp, nhóm hàng và tồn kho.</p>
                </a>
                <a class="feature-card" href="${pageContext.request.contextPath}/reports">
                    <h3>Báo cáo doanh thu</h3>
                    <p>Phân tích doanh thu theo thời gian, cửa hàng và hiệu suất nhân viên bán hàng.</p>
                </a>
            </div>
        </section>

        <c:if test="${not empty recentOrders}">
            <section class="section-card">
                <h3>Đơn hàng gần đây</h3>
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
    </div>
</main>
<footer class="site-footer">
    <div class="wrapper">
        <small>&copy; 2024 QLST &mdash; Tất cả dữ liệu trong tầm tay bạn</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
