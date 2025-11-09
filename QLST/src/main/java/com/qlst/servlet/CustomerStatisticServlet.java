package com.qlst.servlet;

import com.qlst.dao.CustomerStatisticDAO;
import com.qlst.model.CustomerStatistic;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
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
 * Handles the statistics request and forwards the aggregated customer revenue to the view.
 */
public class CustomerStatisticServlet extends HttpServlet {

    private static final String STATISTIC_TYPE_CUSTOMER_REVENUE = "customer-revenue";
    private static final String STATISTIC_TYPE_CUSTOMER_ORDER_COUNT = "customer-order-count";
    private static final String STATISTIC_TYPE_CUSTOMER_PURCHASE_FREQUENCY = "customer-purchase-frequency";
    private static final DateTimeFormatter INPUT_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statisticType = trim(request.getParameter("statisticType"));
        String startParam = trim(request.getParameter("startDate"));
        String endParam = trim(request.getParameter("endDate"));

        request.setAttribute("statisticType", statisticType);
        request.setAttribute("startDate", startParam);
        request.setAttribute("endDate", endParam);

        // Accept all three types but treat them all as customer revenue statistics
        if (statisticType == null || 
            (!STATISTIC_TYPE_CUSTOMER_REVENUE.equalsIgnoreCase(statisticType) && 
             !STATISTIC_TYPE_CUSTOMER_ORDER_COUNT.equalsIgnoreCase(statisticType) &&
             !STATISTIC_TYPE_CUSTOMER_PURCHASE_FREQUENCY.equalsIgnoreCase(statisticType))) {
            request.setAttribute("listCustomerStatistic", Collections.emptyList());
            request.getRequestDispatcher("/jsp/CustomerStatistic.jsp").forward(request, response);
            return;
        }

        if (startParam == null || endParam == null) {
            request.setAttribute("error", "Start date and end date are required.");
            request.setAttribute("listCustomerStatistic", Collections.emptyList());
            request.getRequestDispatcher("/jsp/CustomerStatistic.jsp").forward(request, response);
            return;
        }

        try {
            LocalDate startDateValue = LocalDate.parse(startParam, INPUT_DATE_FORMATTER);
            LocalDate endDateValue = LocalDate.parse(endParam, INPUT_DATE_FORMATTER);
            if (endDateValue.isBefore(startDateValue)) {
                request.setAttribute("error", "End date must not be before start date.");
                request.setAttribute("listCustomerStatistic", Collections.emptyList());
                request.getRequestDispatcher("/jsp/CustomerStatistic.jsp").forward(request, response);
                return;
            }

            Date startDate = Date.from(startDateValue.atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date endDate = Date.from(endDateValue.atStartOfDay(ZoneId.systemDefault()).toInstant());

            List<CustomerStatistic> statistics;
            try (CustomerStatisticDAO dao = new CustomerStatisticDAO()) {
                statistics = dao.getCustomerStatistic(startDate, endDate);
            }
            request.setAttribute("listCustomerStatistic", statistics);
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Invalid date format. Please use yyyy-MM-dd.");
            request.setAttribute("listCustomerStatistic", Collections.emptyList());
        } catch (SQLException e) {
            throw new ServletException("Unable to load customer statistics", e);
        }

        request.getRequestDispatcher("/jsp/CustomerStatistic.jsp").forward(request, response);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String result = value.trim();
        return result.isEmpty() ? null : result;
    }
}
