<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng - QLST</title>
</head>
<body>
<h2>Thống kê khách hàng theo doanh thu</h2>
<form action="${pageContext.request.contextPath}/reports" method="post">
    <label for="startDate">Ngày bắt đầu</label>
    <input type="date" id="startDate" name="startDate" required>

    <label for="endDate">Ngày kết thúc</label>
    <input type="date" id="endDate" name="endDate" required>

    <button type="submit">Xem thống kê</button>
</form>
<section>
    <h3>Danh sách khách hàng</h3>
    <p>TODO: Hiển thị bảng thống kê khách hàng theo doanh thu.</p>
</section>
</body>
</html>
