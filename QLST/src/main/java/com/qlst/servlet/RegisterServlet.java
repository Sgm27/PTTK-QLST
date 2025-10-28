package com.qlst.servlet;

import com.qlst.dao.UserDAO;
import com.qlst.entity.Customer;
import com.qlst.entity.User;
import com.qlst.util.PasswordUtil;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles customer registration.
 */
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = StringUtils.trimToEmpty(req.getParameter("username"));
        String fullName = StringUtils.trimToEmpty(req.getParameter("fullName"));
        String email = StringUtils.trimToEmpty(req.getParameter("email"));
        String phone = StringUtils.trimToEmpty(req.getParameter("phone"));
        String address = StringUtils.trimToEmpty(req.getParameter("address"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleParam = StringUtils.upperCase(StringUtils.trimToEmpty(req.getParameter("role")));
        String role = "MANAGER".equals(roleParam) ? "MANAGER" : "CUSTOMER";

        req.setAttribute("selectedRole", role);

        List<String> errors = new ArrayList<>();
        if (StringUtils.isBlank(username)) {
            errors.add("Tên đăng nhập không được để trống.");
        }
        if (StringUtils.isBlank(fullName)) {
            errors.add("Họ và tên không được để trống.");
        }
        if (StringUtils.isBlank(email)) {
            errors.add("Email không được để trống.");
        }
        if (StringUtils.isBlank(password)) {
            errors.add("Mật khẩu không được để trống.");
        }
        if (!StringUtils.equals(password, confirmPassword)) {
            errors.add("Mật khẩu xác nhận không khớp.");
        }

        try {
            if (userDAO.findByUsername(username).isPresent()) {
                errors.add("Tên đăng nhập đã tồn tại.");
            }
            if (StringUtils.isNotBlank(email) && userDAO.findByEmail(email).isPresent()) {
                errors.add("Email đã được sử dụng.");
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể kiểm tra thông tin người dùng", e);
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("formData", new FormData(username, fullName, email, phone, address, role));
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setRole(role);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setCreatedAt(LocalDateTime.now());

        Customer customer = new Customer();
        customer.setFullName(fullName);
        customer.setEmail(email);
        customer.setPhoneNumber(phone);
        customer.setAddress(StringUtils.defaultIfBlank(address, null));
        customer.setJoinedAt(LocalDateTime.now());

        try {
            userDAO.createCustomerAccount(user, customer);
        } catch (SQLException e) {
            throw new ServletException("Không thể lưu người dùng mới", e);
        }

        resp.sendRedirect(req.getContextPath() + "/login?registered=true");
    }

    private static class FormData {
        private final String username;
        private final String fullName;
        private final String email;
        private final String phone;
        private final String address;
        private final String role;

        private FormData(String username, String fullName, String email, String phone, String address, String role) {
            this.username = username;
            this.fullName = fullName;
            this.email = email;
            this.phone = phone;
            this.address = address;
            this.role = role;
        }

        public String getUsername() {
            return username;
        }

        public String getFullName() {
            return fullName;
        }

        public String getEmail() {
            return email;
        }

        public String getPhone() {
            return phone;
        }

        public String getAddress() {
            return address;
        }

        public String getRole() {
            return role;
        }

    }
}
