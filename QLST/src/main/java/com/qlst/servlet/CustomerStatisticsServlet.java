package com.qlst.servlet;

import com.qlst.dao.StatisticsDAO;
import com.qlst.dto.CustomerRevenue;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Servlet chịu trách nhiệm hiển thị trang thống kê doanh thu khách hàng.
 */
public class CustomerStatisticsServlet extends HttpServlet {

    private final StatisticsDAO statisticsDAO = new StatisticsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp, false);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        handleRequest(req, resp, true);
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp, boolean validateInputs)
            throws ServletException, IOException {
        String startParam = StringUtils.trimToEmpty(req.getParameter("startDate"));
        String endParam = StringUtils.trimToEmpty(req.getParameter("endDate"));

        boolean hasCustomRange = StringUtils.isNotBlank(startParam) && StringUtils.isNotBlank(endParam);
        if (!hasCustomRange && !validateInputs) {
            LocalDate defaultEnd = LocalDate.now();
            LocalDate defaultStart = defaultEnd.minusDays(29);
            startParam = defaultStart.toString();
            endParam = defaultEnd.toString();
        }

        req.setAttribute("startDate", startParam);
        req.setAttribute("endDate", endParam);

        if (StringUtils.isBlank(startParam) || StringUtils.isBlank(endParam)) {
            if (validateInputs) {
                req.setAttribute("error", "Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc.");
            }
            req.getRequestDispatcher("/jsp/customer_statistics.jsp").forward(req, resp);
            return;
        }

        try {
            LocalDate startDate = LocalDate.parse(startParam);
            LocalDate endDate = LocalDate.parse(endParam);
            if (endDate.isBefore(startDate)) {
                req.setAttribute("error", "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
                req.getRequestDispatcher("/jsp/customer_statistics.jsp").forward(req, resp);
                return;
            }

            List<CustomerRevenue> revenueList = statisticsDAO.calculateCustomerRevenue(startDate, endDate);
            req.setAttribute("customerRevenue", revenueList);
        } catch (DateTimeParseException e) {
            req.setAttribute("error", "Định dạng ngày không hợp lệ.");
        } catch (SQLException e) {
            throw new ServletException("Không thể lấy dữ liệu thống kê khách hàng", e);
        }

        req.getRequestDispatcher("/jsp/customer_statistics.jsp").forward(req, resp);
    }
}
