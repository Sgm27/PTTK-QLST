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
<div class="app-shell">
    <header class="app-header">
        <div class="app-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
                <span class="brand__mark">QL</span>
                <span>QLST</span>
            </a>
            <p class="app-tagline">Phân tích doanh thu và hành vi khách hàng trong nháy mắt</p>
            <nav class="primary-nav" aria-label="Liên kết nhanh">
                <a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a>
                <a href="${pageContext.request.contextPath}/customer" class="is-active">Khách hàng</a>
                <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            </nav>
        </div>
    </header>
    <div class="app-body">
        <aside class="app-sidebar" aria-label="Điều hướng quản lý">
            <div>
                <div class="sidebar-title">Thông tin khách hàng</div>
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard">Tổng quan</a>
                    <a href="${pageContext.request.contextPath}/customer" class="is-current">Doanh thu theo khách hàng</a>
                    <a href="${pageContext.request.contextPath}/products">Chương trình khuyến mại</a>
                    <a href="${pageContext.request.contextPath}/reports">Báo cáo tổng hợp</a>
                </nav>
            </div>
            <p class="sidebar-note">Sử dụng khoảng thời gian phù hợp để nhận diện nhóm khách hàng giá trị cao.</p>
        </aside>
        <main class="app-content">
            <section class="section-card" aria-labelledby="customer-analytics">
                <div class="section-header">
                    <div>
                        <h2 id="customer-analytics">Thống kê khách hàng theo doanh thu</h2>
                        <p>Chọn khoảng thời gian để xem doanh thu, số đơn hàng và lịch sử mua sắm của từng khách hàng.</p>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>

                <section class="form-card" aria-labelledby="customer-report">
                    <div class="section-header">
                        <div>
                            <h3 id="customer-report">Báo cáo doanh thu theo khách hàng</h3>
                            <p>Lọc theo ngày để đánh giá mức độ đóng góp của từng khách hàng.</p>
                        </div>
                    </div>
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
                                        <th scope="col" class="text-right">Chi tiết</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${customerRevenue}">
                                        <tr class="${item.customerId == selectedCustomerId ? 'table-row-selected' : ''}">
                                            <td>${item.customerId}</td>
                                            <td>${item.customerName}</td>
                                            <td>${item.revenue}</td>
                                            <td class="text-right">${item.orderCount}</td>
                                            <td class="table-actions">
                                                <form action="${pageContext.request.contextPath}/reports" method="post" class="inline-form">
                                                    <input type="hidden" name="startDate" value="${startDate}">
                                                    <input type="hidden" name="endDate" value="${endDate}">
                                                    <input type="hidden" name="customerId" value="${item.customerId}">
                                                    <button type="submit" class="btn btn-secondary btn-small">Xem chi tiết</button>
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
                        <div class="table-card customer-detail" aria-labelledby="customer-transactions" aria-live="polite">
                            <div class="section-header">
                                <div>
                                    <h3 id="customer-transactions">Chi tiết giao dịch: <span class="highlight-text"><c:out value="${selectedCustomerName}" default="Khách hàng #${selectedCustomerId}"/></span></h3>
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
                                    <p class="empty-state">Không có giao dịch nào của khách hàng trong khoảng thời gian đã chọn.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </section>
            </section>

            <c:if test="${not empty customerOrders}">
                <section class="section-card" aria-labelledby="customer-orders">
                    <div class="section-header">
                        <div>
                            <h3 id="customer-orders">Đơn hàng của tôi</h3>
                            <p>Lọc đơn hàng theo thời gian để theo dõi lịch sử mua sắm và tổng chi tiêu.</p>
                        </div>
                    </div>
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

                    <p class="status-pill">Tổng chi tiêu: <strong>${totalSpent}</strong></p>

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
        </main>
    </div>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Hiểu khách hàng để phục vụ tốt hơn</small>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
