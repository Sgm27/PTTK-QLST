<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.qlst.model.Member" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành công - QLST</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <style>
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .success-icon {
            text-align: center;
            margin-bottom: 20px;
        }
        .success-icon svg {
            width: 80px;
            height: 80px;
            fill: #28a745;
        }
        .success-title {
            text-align: center;
            color: #28a745;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .success-message {
            text-align: center;
            font-size: 16px;
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .member-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .member-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
        }
        .info-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            width: 150px;
            flex-shrink: 0;
        }
        .info-value {
            color: #333;
            flex: 1;
        }
        .action-buttons {
            text-align: center;
        }
        .btn-primary {
            display: inline-block;
            padding: 12px 40px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            transition: background 0.3s ease;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .btn-secondary {
            display: inline-block;
            padding: 12px 40px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            margin-left: 10px;
            transition: background 0.3s ease;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
    </style>
</head>
<body>
    <%
        Member member = (Member) request.getAttribute("member");
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
    %>

    <div class="success-container">
        <!-- Success Icon -->
        <div class="success-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
        </div>

        <!-- Success Title -->
        <h1 class="success-title">Đăng ký thành công!</h1>

        <!-- Success Message -->
        <p class="success-message">
            Chúc mừng bạn đã tạo tài khoản thành công!<br>
            Bạn có thể đăng nhập ngay bây giờ để sử dụng các dịch vụ của chúng tôi.
        </p>

        <!-- Member Information -->
        <div class="member-info">
            <h3>Thông tin tài khoản của bạn:</h3>
            
            <div class="info-row">
                <span class="info-label">Họ và tên:</span>
                <span class="info-value"><%= member.getName() != null ? member.getName() : "" %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Email:</span>
                <span class="info-value"><%= member.getEmail() != null ? member.getEmail() : "" %></span>
            </div>
            
            <% if (member.getPhone() != null && !member.getPhone().isEmpty()) { %>
            <div class="info-row">
                <span class="info-label">Số điện thoại:</span>
                <span class="info-value"><%= member.getPhone() %></span>
            </div>
            <% } %>
            
            <% if (member.getAddress() != null && !member.getAddress().isEmpty()) { %>
            <div class="info-row">
                <span class="info-label">Địa chỉ:</span>
                <span class="info-value"><%= member.getAddress() %></span>
            </div>
            <% } %>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="<%= request.getContextPath() %>/login?registered=true" class="btn-primary">
                Đăng nhập ngay
            </a>
            <a href="<%= request.getContextPath() %>/" class="btn-secondary">
                Về trang chủ
            </a>
        </div>
    </div>
</body>
</html>
