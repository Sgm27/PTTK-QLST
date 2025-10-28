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
            <a href="${pageContext.request.contextPath}/reports">Thống kê khách hàng</a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card stack" aria-labelledby="report-title">
        <h1 id="report-title">Thống kê khách hàng</h1>

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
                            <th scope="col">Số giao dịch</th>
                            <th scope="col" class="table-actions">Chi tiết</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${customerRevenue}">
                            <tr class="${item.customerId == selectedCustomerId ? 'table-row-selected' : ''}">
                                <td>${item.customerId}</td>
                                <td>${item.customerName}</td>
                                <td>${item.revenue}</td>
                                <td>${item.transactionCount}</td>
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
                <h2 id="customer-detail-heading">Chi tiết giao dịch</h2>
                <div class="detail-meta">
                    <span>Khách hàng: <strong><c:out value="${selectedCustomerName}" default="Khách hàng #${selectedCustomerId}"/></strong></span>
                    <span>Khoảng thời gian: <strong>${startDate}</strong> - <strong>${endDate}</strong></span>
                    <span>Tổng chi tiêu: <strong>${selectedCustomerTotal}</strong></span>
                </div>
                <c:choose>
                    <c:when test="${not empty selectedCustomerTransactions}">
                        <div class="table-responsive">
                            <table aria-label="Danh sách giao dịch của khách hàng">
                                <thead>
                                <tr>
                                    <th scope="col">Mã giao dịch</th>
                                    <th scope="col">Thời gian</th>
                                    <th scope="col">Mô tả</th>
                                    <th scope="col">Số tiền</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="transaction" items="${selectedCustomerTransactions}">
                                    <tr>
                                        <td>${transaction.id}</td>
                                        <td><c:out value="${transaction.transactionDate}"/></td>
                                        <td><c:out value="${transaction.description}" default="-"/></td>
                                        <td>${transaction.amount}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="form-note">Không có giao dịch trong khoảng thời gian đã chọn.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
