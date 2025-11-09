package com.qlst.servlet;

import com.qlst.dao.CustomerDAO;
import com.qlst.dao.OrderDAO;
import com.qlst.model.Customer;
import com.qlst.model.CustomerStatistic;
import com.qlst.model.Order;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.http;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Loads the order list for a specific customer and forwards it to the detail view.
 */
public class OrderServlet extends HttpServlet {

    private static final DateTimeFormatter INPUT_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerIdParam = trim(request.getParameter("customerId"));
        String startParam = trim(request.getParameter("startDate"));
        String endParam = trim(request.getParameter("endDate"));

        request.setAttribute("startDate", startParam);
        request.setAttribute("endDate", endParam);

        if (customerIdParam == null) {
            request.setAttribute("error", "Customer id is required.");
            request.setAttribute("lstOrder", Collections.emptyList());
            request.getRequestDispatcher("/jsp/CustomerOrder.jsp").forward(request, response);
            return;
        }

        if (startParam == null || endParam == null) {
            request.setAttribute("error", "Start date and end date are required.");
            request.setAttribute("lstOrder", Collections.emptyList());
            request.getRequestDispatcher("/jsp/CustomerOrder.jsp").forward(request, response);
            return;
        }

        try {
            String customerId = customerIdParam; 
            LocalDate startDateValue = LocalDate.parse(startParam, INPUT_DATE_FORMATTER);
            LocalDate endDateValue = LocalDate.parse(endParam, INPUT_DATE_FORMATTER);
            if (endDateValue.isBefore(startDateValue)) {
                request.setAttribute("error", "End date must not be before start date.");
                request.setAttribute("lstOrder", Collections.emptyList());
                request.getRequestDispatcher("/jsp/CustomerOrder.jsp").forward(request, response);
                return;
            }

            Date startDate = Date.from(startDateValue.atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date endDate = Date.from(endDateValue.atStartOfDay(ZoneId.systemDefault()).toInstant());

            List<Order> orders;
            float totalPrice;
            try (OrderDAO orderDAO = new OrderDAO()) {
                orders = orderDAO.getOrderList(customerId, startDate, endDate);
                totalPrice = orderDAO.sumTotalPrice(orders);
            }

            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.resolveCustomer(customerId, orders);
            CustomerStatistic customerStatistic = new CustomerStatistic(customer, totalPrice);

            request.setAttribute("lstOrder", orders);
            request.setAttribute("customerStatistic", customerStatistic);
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Invalid date format. Please use yyyy-MM-dd.");
            request.setAttribute("lstOrder", Collections.emptyList());
        } catch (SQLException e) {
            throw new ServletException("Unable to load orders", e);
        }

        request.getRequestDispatcher("/jsp/CustomerOrder.jsp").forward(request, response);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String result = value.trim();
        return result.isEmpty() ? null : result;
    }
}

