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
    <div class="header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span>QLST</span>
        </a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register">Đăng ký thành viên</a>
            <a href="${pageContext.request.contextPath}/reports" class="is-active">Thống kê khách hàng</a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card form-card" aria-labelledby="report-title">
        <div>
            <h1 id="report-title">Thống kê khách hàng theo doanh thu</h1>
            <p>Chọn khoảng thời gian để xem danh sách khách hàng và tổng doanh thu tương ứng.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reports" method="post" class="form-grid two-column">
            <div>
                <label for="startDate">Ngày bắt đầu</label>
                <input type="date" id="startDate" name="startDate" value="${startDate}" required>
            </div>
            <div>
                <label for="endDate">Ngày kết thúc</label>
                <input type="date" id="endDate" name="endDate" value="${endDate}" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">Xem thống kê</button>
            </div>
        </form>

        <c:if test="${not empty customerRevenue}">
            <div class="table-card" aria-live="polite">
                <div class="table-responsive">
                    <table aria-label="Báo cáo doanh thu khách hàng">
                        <thead>
                        <tr>
                            <th scope="col">Mã khách hàng</th>
                            <th scope="col">Họ tên</th>
                            <th scope="col">Tổng doanh thu</th>
                            <th scope="col">Số đơn</th>
                            <th scope="col" class="table-actions">Chi tiết</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${customerRevenue}">
                            <tr class="${item.customerId == selectedCustomerId ? 'table-row-selected' : ''}">
                                <td>${item.customerId}</td>
                                <td>${item.customerName}</td>
                                <td>${item.revenue}</td>
                                <td>${item.orderCount}</td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/reports" method="post" class="inline-form">
                                        <input type="hidden" name="startDate" value="${startDate}">
                                        <input type="hidden" name="endDate" value="${endDate}">
                                        <input type="hidden" name="customerId" value="${item.customerId}">
                                        <button type="submit" class="btn btn-secondary">Xem</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty selectedCustomerId}">
            <div class="table-card customer-detail" aria-labelledby="customer-detail-heading" aria-live="polite">
                <div class="section-header">
                    <div>
                        <h2 id="customer-detail-heading">Chi tiết giao dịch</h2>
                        <p>Khách hàng: <strong><c:out value="${selectedCustomerName}" default="Khách hàng #${selectedCustomerId}"/></strong></p>
                        <p>Khoảng thời gian: <strong>${startDate}</strong> đến <strong>${endDate}</strong></p>
                    </div>
                    <div class="stat-chip">
                        <span>Tổng chi tiêu</span>
                        <strong>${selectedCustomerTotal}</strong>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${not empty selectedCustomerOrders}">
                        <div class="table-responsive">
                            <table aria-label="Danh sách giao dịch của khách hàng">
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
                                <c:forEach var="order" items="${selectedCustomerOrders}">
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
                    </c:when>
                    <c:otherwise>
                        <p>Không có giao dịch nào trong khoảng thời gian đã chọn.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Theo dõi doanh thu khách hàng hiệu quả</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
