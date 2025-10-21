package com.qlst.servlet;

import com.qlst.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Manages customer-specific interactions such as viewing order history.
 */
public class CustomerServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Load customer orders and forward to JSP
        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Handle customer actions such as filtering or confirming pickup
        resp.sendRedirect(req.getContextPath() + "/customer");
    }
}
