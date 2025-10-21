<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng - QLST</title>
</head>
<body>
<h2>Thống kê khách hàng theo doanh thu</h2>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>

<section>
    <h3>Báo cáo doanh thu theo khách hàng</h3>
    <form action="${pageContext.request.contextPath}/reports" method="post">
        <label for="startDate">Ngày bắt đầu</label>
        <input type="date" id="startDate" name="startDate" value="${startDate}" required>

        <label for="endDate">Ngày kết thúc</label>
        <input type="date" id="endDate" name="endDate" value="${endDate}" required>

        <button type="submit">Xem thống kê</button>
    </form>

    <c:if test="${not empty customerRevenue}">
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
            <tr>
                <th>Mã khách hàng</th>
                <th>Họ tên</th>
                <th>Tổng doanh thu</th>
                <th>Số đơn hàng</th>
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
    </c:if>
</section>

<c:if test="${not empty customerOrders}">
    <section>
        <h3>Đơn hàng của tôi</h3>
        <form action="${pageContext.request.contextPath}/customer" method="post">
            <label for="filterStart">Ngày bắt đầu</label>
            <input type="date" id="filterStart" name="startDate" value="${startDate}">

            <label for="filterEnd">Ngày kết thúc</label>
            <input type="date" id="filterEnd" name="endDate" value="${endDate}">

            <button type="submit">Lọc</button>
        </form>

        <p>Tổng chi tiêu: <strong>${totalSpent}</strong></p>

        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th>Trạng thái</th>
                <th>Loại đơn</th>
                <th>Địa chỉ giao hàng</th>
                <th>Tổng tiền</th>
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
    </section>
</c:if>
</body>
</html>
