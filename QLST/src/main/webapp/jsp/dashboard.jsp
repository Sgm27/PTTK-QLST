<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - QLST</title>
</head>
<body>
<h2>Bảng điều khiển quản lý</h2>
<nav>
    <ul>
        <li><a href="${pageContext.request.contextPath}/reports">Báo cáo</a></li>
        <li><a href="${pageContext.request.contextPath}/products">Quản lý sản phẩm</a></li>
        <li><a href="${pageContext.request.contextPath}/warehouse">Quản lý kho</a></li>
    </ul>
</nav>
<section>
    <p>Tổng doanh thu: <strong>${totalRevenue}</strong></p>
    <p>Tổng số đơn hàng: <strong>${ordersCount}</strong></p>

    <h3>Đơn hàng theo trạng thái</h3>
    <c:if test="${not empty ordersByStatus}">
        <ul>
            <c:forEach var="entry" items="${ordersByStatus}">
                <li>${entry.key}: ${entry.value}</li>
            </c:forEach>
        </ul>
    </c:if>

    <h3>Đơn hàng gần đây</h3>
    <c:if test="${not empty recentOrders}">
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
            <tr>
                <th>ID</th>
                <th>Khách hàng</th>
                <th>Ngày đặt</th>
                <th>Trạng thái</th>
                <th>Tổng tiền</th>
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
    </c:if>
    <p>Vui lòng chọn chức năng để xem thống kê hoặc quản lý chi tiết.</p>
</section>
</body>
</html>
