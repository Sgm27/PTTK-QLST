package com.qlst.servlet;

import com.qlst.dao.OrderDAO;
import com.qlst.dto.CustomerRevenue;
import com.qlst.entity.Order;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Provides reporting views for managers.
 */
public class ManagerReportServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp, false);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        processRequest(req, resp, true);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp, boolean validateInputs)
            throws ServletException, IOException {
        String startDateParam = StringUtils.trimToEmpty(req.getParameter("startDate"));
        String endDateParam = StringUtils.trimToEmpty(req.getParameter("endDate"));

        if (StringUtils.isNotBlank(startDateParam)) {
            req.setAttribute("startDate", startDateParam);
        }
        if (StringUtils.isNotBlank(endDateParam)) {
            req.setAttribute("endDate", endDateParam);
        }

        if (StringUtils.isBlank(startDateParam) || StringUtils.isBlank(endDateParam)) {
            if (validateInputs) {
                req.setAttribute("error", "Vui lòng chọn khoảng thời gian hợp lệ.");
            }
            req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
            return;
        }

        try {
            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);
            if (endDate.isBefore(startDate)) {
                req.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu.");
            } else {
                List<CustomerRevenue> revenueList = orderDAO.calculateCustomerRevenue(startDate, endDate);
                req.setAttribute("customerRevenue", revenueList);

                String customerIdParam = req.getParameter("customerId");
                if (StringUtils.isNotBlank(customerIdParam)) {
                    try {
                        Long customerId = Long.valueOf(customerIdParam);
                        List<Order> customerOrders = orderDAO.findByCustomerAndDateRange(customerId, startDate, endDate);
                        req.setAttribute("selectedCustomerOrders", customerOrders);
                        req.setAttribute("selectedCustomerTotal", calculateTotalRevenue(customerOrders));
                        req.setAttribute("selectedCustomerId", customerId);
                        revenueList.stream()
                                .filter(item -> item.getCustomerId().equals(customerId))
                                .map(CustomerRevenue::getCustomerName)
                                .findFirst()
                                .ifPresent(name -> req.setAttribute("selectedCustomerName", name));
                    } catch (NumberFormatException ex) {
                        req.setAttribute("error", "Mã khách hàng không hợp lệ.");
                    } catch (SQLException sqlEx) {
                        throw new ServletException("Không thể tải lịch sử giao dịch của khách hàng", sqlEx);
                    }
                }
            }
        } catch (DateTimeParseException e) {
            req.setAttribute("error", "Định dạng ngày không hợp lệ.");
        } catch (SQLException e) {
            throw new ServletException("Không thể tạo báo cáo doanh thu", e);
        }

        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }

    private BigDecimal calculateTotalRevenue(List<Order> orders) {
        return orders.stream()
                .map(Order::getTotalAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
