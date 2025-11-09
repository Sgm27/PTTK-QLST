package com.qlst.servlet;

import com.qlst.dao.OrderDAO;
import com.qlst.model.Order;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet to display detailed information of a specific order including product list.
 */
public class CustomerOrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdParam = trim(request.getParameter("orderId"));
        String customerIdParam = trim(request.getParameter("customerId"));
        String startParam = trim(request.getParameter("startDate"));
        String endParam = trim(request.getParameter("endDate"));

        // Pass parameters for back navigation
        request.setAttribute("customerId", customerIdParam);
        request.setAttribute("startDate", startParam);
        request.setAttribute("endDate", endParam);

        if (orderIdParam == null) {
            request.setAttribute("error", "Order ID is required.");
            request.getRequestDispatcher("/jsp/CustomerOrderDetail.jsp").forward(request, response);
            return;
        }

        try {
            String orderId = orderIdParam;

            Order order;
            try (OrderDAO orderDAO = new OrderDAO()) {
                order = orderDAO.getOrderDetail(orderId);
            }

            if (order == null) {
                request.setAttribute("error", "Order not found with ID: " + orderId);
            } else {
                request.setAttribute("order", order);
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to load order details", e);
        }

        request.getRequestDispatcher("/jsp/CustomerOrderDetail.jsp").forward(request, response);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String result = value.trim();
        return result.isEmpty() ? null : result;
    }
}
