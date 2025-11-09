<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trung tâm quản lý - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPage" value="statistics"/>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>
<c:if test="${not empty currentUser}">
    <c:set var="displayName" value="${not empty currentUser.fullName ? currentUser.fullName : currentUser.username}"/>
</c:if>

<header class="top-bar">
    <div class="top-bar__inner">
        <a class="brand" href="${ctx}/login">
            <span class="brand__badge">QL</span>
            <span>QLST</span>
        </a>
        <div class="top-bar__links">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <span class="nav-pill">Xin chào, <c:out value="${displayName}"/></span>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                    <a class="nav-link nav-link--logout" href="${ctx}/logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
                    <a class="nav-link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page">
        <div class="page-header">
            <p class="page-header__eyebrow">Trung tâm quản lý</p>
            <h1 class="page-header__title">Chức năng Nhân viên Quản lí</h1>
            <p class="page-header__subtitle">
                Chọn chức năng bạn muốn thực hiện để truy cập các báo cáo và thống kê.
            </p>
        </div>

        <!-- Chức năng 1: Xem thống kê mặt hàng -->
        <section class="card">
            <div>
                <h2 class="card__title">Thống kê Mặt hàng</h2>
                <p class="card__subtitle">
                    Xem thống kê mặt hàng theo doanh thu trong khoảng thời gian cụ thể. 
                    Phân tích chi tiết các lần giao dịch của từng mặt hàng.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Xem thống kê mặt hàng
                </a>
            </div>
        </section>

        <!-- Chức năng 2: Xem thống kê nhà cung cấp -->
        <section class="card">
            <div>
                <h2 class="card__title">Thống kê Nhà cung cấp</h2>
                <p class="card__subtitle">
                    Xem thống kê nhà cung cấp theo số lượng hàng nhập. 
                    Theo dõi chi tiết các lần nhập hàng và hóa đơn của từng nhà cung cấp.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Xem thống kê nhà cung cấp
                </a>
            </div>
        </section>

        <!-- Chức năng 3: Xem thống kê khách hàng -->
        <section class="card">
            <div>
                <h2 class="card__title">Thống kê Khách hàng</h2>
                <p class="card__subtitle">
                    Xem thống kê khách hàng theo doanh thu trong khoảng thời gian cụ thể. 
                    Phân tích chi tiết các lần giao dịch của từng khách hàng.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Xem thống kê khách hàng
                </a>
            </div>
        </section>

        <!-- Chức năng 4: Báo cáo tổng hợp -->
        <section class="card">
            <div>
                <h2 class="card__title">Báo cáo Tổng hợp</h2>
                <p class="card__subtitle">
                    Xem báo cáo tổng hợp về doanh thu, hiệu suất kinh doanh và các chỉ số quan trọng khác.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Xem báo cáo tổng hợp
                </a>
            </div>
        </section>

        <!-- Chức năng 5: Quản lý Báo cáo -->
        <section class="card">
            <div>
                <h2 class="card__title">Quản lý Báo cáo</h2>
                <p class="card__subtitle">
                    Quản lý và theo dõi các báo cáo đã tạo. 
                    Xuất báo cáo ra file hoặc chia sẻ với các bộ phận khác.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Quản lý báo cáo
                </a>
            </div>
        </section>

        <!-- Chức năng 6: Phân tích Xu hướng -->
        <section class="card">
            <div>
                <h2 class="card__title">Phân tích Xu hướng</h2>
                <p class="card__subtitle">
                    Phân tích xu hướng kinh doanh theo thời gian. 
                    So sánh doanh thu giữa các kỳ và dự đoán xu hướng tương lai.
                </p>
            </div>
            <div class="button-row">
                <a class="btn btn--primary" href="${ctx}/jsp/SelectStatisticType.jsp">
                    Phân tích xu hướng
                </a>
            </div>
        </section>
    </div>
</main>
</body>
</html>
