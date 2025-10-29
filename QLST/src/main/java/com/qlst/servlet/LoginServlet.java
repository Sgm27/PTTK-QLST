package com.qlst.servlet;

import com.qlst.dao.UserDAO;
import com.qlst.entity.User;
import com.qlst.util.PasswordUtil;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * Handles authentication logic for system users.
 */
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/statistics/customers");
            return;
        }

        if ("true".equals(req.getParameter("registered"))) {
            req.setAttribute("message", "Đăng ký thành công. Vui lòng đăng nhập.");
        } else if ("success".equals(req.getParameter("logout"))) {
            req.setAttribute("message", "Bạn đã đăng xuất khỏi hệ thống.");
        }
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = StringUtils.trimToEmpty(req.getParameter("username"));
        String password = req.getParameter("password");

        if (StringUtils.isBlank(username) || StringUtils.isBlank(password)) {
            req.setAttribute("error", "Tên đăng nhập và mật khẩu không được để trống.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        try {
            Optional<User> userOptional = userDAO.findByUsername(username);
            if (userOptional.isEmpty() || !PasswordUtil.matches(password, userOptional.get().getPasswordHash())) {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác.");
                req.setAttribute("username", username);
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
                return;
            }

            User authenticated = userOptional.get();
            authenticated.setPasswordHash(null);
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", authenticated);
            resp.sendRedirect(req.getContextPath() + "/statistics/customers");
        } catch (SQLException e) {
            throw new ServletException("Không thể xử lý đăng nhập: " + e.getMessage(), e);
        }
    }
}
