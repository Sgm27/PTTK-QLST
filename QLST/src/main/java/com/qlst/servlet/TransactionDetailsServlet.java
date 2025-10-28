package com.qlst.servlet;

import com.qlst.dao.CustomerDAO;
import com.qlst.dao.StatisticsDAO;
import com.qlst.entity.Customer;
import com.qlst.entity.Transaction;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

/**
 * Servlet hiển thị chi tiết giao dịch cho một khách hàng cụ thể.
 */
public class TransactionDetailsServlet extends HttpServlet {

    private final StatisticsDAO statisticsDAO = new StatisticsDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String customerIdParam = StringUtils.trimToEmpty(req.getParameter("customerId"));
        String startParam = StringUtils.trimToEmpty(req.getParameter("startDate"));
        String endParam = StringUtils.trimToEmpty(req.getParameter("endDate"));

        req.setAttribute("startDate", startParam);
        req.setAttribute("endDate", endParam);

        if (StringUtils.isAnyBlank(customerIdParam, startParam, endParam)) {
            req.setAttribute("error", "Thiếu thông tin bắt buộc để hiển thị chi tiết giao dịch.");
            req.getRequestDispatcher("/jsp/transaction_details.jsp").forward(req, resp);
            return;
        }

        try {
            long customerId = Long.parseLong(customerIdParam);
            LocalDate startDate = LocalDate.parse(startParam);
            LocalDate endDate = LocalDate.parse(endParam);
            if (endDate.isBefore(startDate)) {
                req.setAttribute("error", "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
                req.getRequestDispatcher("/jsp/transaction_details.jsp").forward(req, resp);
                return;
            }

            Optional<Customer> customerOptional = customerDAO.findById(customerId);
            if (customerOptional.isEmpty()) {
                req.setAttribute("error", "Không tìm thấy thông tin khách hàng.");
                req.getRequestDispatcher("/jsp/transaction_details.jsp").forward(req, resp);
                return;
            }

            List<Transaction> transactions = statisticsDAO.findTransactionsByCustomerAndDateRange(customerId, startDate, endDate);
            BigDecimal total = statisticsDAO.calculateTotal(transactions);

            req.setAttribute("customer", customerOptional.get());
            req.setAttribute("transactions", transactions);
            req.setAttribute("totalAmount", total);
            req.setAttribute("timeFormatter", DATE_TIME_FORMATTER);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã khách hàng không hợp lệ.");
        } catch (DateTimeParseException e) {
            req.setAttribute("error", "Định dạng ngày không hợp lệ.");
        } catch (SQLException e) {
            throw new ServletException("Không thể lấy dữ liệu giao dịch khách hàng", e);
        }

        req.getRequestDispatcher("/jsp/transaction_details.jsp").forward(req, resp);
    }
}
