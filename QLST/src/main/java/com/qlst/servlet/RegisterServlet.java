package com.qlst.servlet;

import com.qlst.dao.UserDAO;
import com.qlst.entity.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

/**
 * Handles customer and employee registration.
 */
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Implement registration logic and validation
        User user = new User();
        user.setUsername(req.getParameter("username"));
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhoneNumber(req.getParameter("phone"));
        user.setRole("CUSTOMER");
        user.setCreatedAt(LocalDateTime.now());

        // TODO: Persist user and redirect with success message
        resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
    }
}
