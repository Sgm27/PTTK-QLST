<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết khách hàng - QLST</title>
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
            <a href="${pageContext.request.contextPath}/login" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <span class="nav-label">Đăng nhập</span>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a5 5 0 10-5-5 5 5 0 005 5zm7 1h-3v-3h-2v3h-3v2h3v3h2v-3h3zM4 18.25C4 15.9 7.13 14 12 14v2c-3.87 0-6 1.23-6 2.25V20H4z"/></svg>
                </span>
                <span class="nav-label">Đăng ký</span>
            </a>
            <a href="${pageContext.request.contextPath}/reports" class="nav-link is-active">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M5 4h3v16H5zm5 6h3v10h-3zm5-4h3v14h-3z"/></svg>
                </span>
                <span class="nav-label">Thống kê</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card detail-card" aria-labelledby="customer-detail-heading">
        <div class="detail-header">
            <div class="detail-header__meta">
                <h1 id="customer-detail-heading">Chi tiết giao dịch khách hàng</h1>
                <p><strong><c:out value="${selectedCustomerName}" default="Khách hàng #${selectedCustomerId}"/></strong> &mdash; Mã khách hàng: <strong>${selectedCustomerId}</strong></p>
                <p>Khoảng thời gian: <strong>${startDate}</strong> &ndash; <strong>${endDate}</strong></p>
            </div>
            <div class="section-header__actions">
                <c:url var="backUrl" value="/reports">
                    <c:param name="startDate" value="${startDate}"/>
                    <c:param name="endDate" value="${endDate}"/>
                    <c:param name="submitted" value="true"/>
                </c:url>
                <a class="btn btn-ghost" href="${backUrl}">Quay lại thống kê</a>
            </div>
        </div>

        <div class="detail-metrics" aria-live="polite">
            <div class="detail-metric">
                <span>Tổng chi tiêu</span>
                <strong>${selectedCustomerTotal}</strong>
            </div>
            <div class="detail-metric">
                <span>Số đơn hàng</span>
                <strong>${selectedCustomerOrderCount}</strong>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty selectedCustomerOrders}">
                <div class="table-card">
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
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state" aria-live="polite">
                    <p><strong>Không có giao dịch nào.</strong> Khách hàng chưa phát sinh đơn hàng trong khoảng thời gian đã chọn.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Theo dõi doanh thu khách hàng hiệu quả</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
