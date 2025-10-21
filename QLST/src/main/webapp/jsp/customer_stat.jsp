<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng - QLST</title>
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
        <div class="tagline">Phân tích doanh thu và hành vi khách hàng trong nháy mắt</div>
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
            <h2>Thống kê khách hàng theo doanh thu</h2>
            <p class="page-intro">Chọn khoảng thời gian để xem tổng doanh thu, số đơn hàng và lịch sử mua sắm của từng khách hàng.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <section class="form-card" aria-labelledby="customer-report">
                <h3 id="customer-report">Báo cáo doanh thu theo khách hàng</h3>
                <form action="${pageContext.request.contextPath}/reports" method="post" class="form-grid two-column">
                    <div>
                        <label for="startDate">Ngày bắt đầu</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                    </div>
                    <div>
                        <label for="endDate">Ngày kết thúc</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                    </div>
                    <div class="form-actions full-width">
                        <button type="submit" class="btn btn-primary">Xem thống kê</button>
                    </div>
                </form>

                <c:if test="${not empty customerRevenue}">
                    <div class="table-card">
                        <div class="table-responsive">
                            <table aria-label="Báo cáo doanh thu khách hàng">
                                <thead>
                                <tr>
                                    <th scope="col">Mã khách hàng</th>
                                    <th scope="col">Họ tên</th>
                                    <th scope="col">Tổng doanh thu</th>
                                    <th scope="col">Số đơn hàng</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${customerRevenue}">
                                    <tr>
                                        <td>${item.customerId}</td>
                                        <td>${item.customerName}</td>
                                        <td>${item.revenue}</td>
                                        <td>${item.orderCount}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>
            </section>
        </section>

        <c:if test="${not empty customerOrders}">
            <section class="section-card">
                <h3>Đơn hàng của tôi</h3>
                <p class="page-intro">Lọc đơn hàng theo thời gian để theo dõi lịch sử mua sắm và tổng chi tiêu.</p>
                <form action="${pageContext.request.contextPath}/customer" method="post" class="form-grid two-column">
                    <div>
                        <label for="filterStart">Ngày bắt đầu</label>
                        <input type="date" id="filterStart" name="startDate" value="${startDate}">
                    </div>
                    <div>
                        <label for="filterEnd">Ngày kết thúc</label>
                        <input type="date" id="filterEnd" name="endDate" value="${endDate}">
                    </div>
                    <div class="form-actions full-width">
                        <button type="submit" class="btn btn-primary">Lọc</button>
                    </div>
                </form>

                <p>Tổng chi tiêu: <strong>${totalSpent}</strong></p>

                <div class="table-card">
                    <div class="table-responsive">
                        <table aria-label="Đơn hàng của khách hàng">
                            <thead>
                            <tr>
                                <th scope="col">Mã đơn</th>
                                <th scope="col">Ngày đặt</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col">Loại đơn</th>
                                <th scope="col">Địa chỉ giao hàng</th>
                                <th scope="col">Tổng tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="order" items="${customerOrders}">
                                <tr>
                                    <td>${order.id}</td>
                                    <td><c:out value="${order.orderDate}"/></td>
                                    <td>${order.status}</td>
                                    <td>${order.orderType}</td>
                                    <td><c:out value="${order.deliveryAddress}" default="-"/></td>
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
        <small>&copy; 2024 QLST &mdash; Hiểu khách hàng để phục vụ tốt hơn</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
