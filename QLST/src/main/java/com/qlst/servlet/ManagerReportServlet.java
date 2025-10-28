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

    private void processRequest(HttpServletRequest req, HttpServletResponse resp, boolean triggeredByPost)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        boolean detailView = pathInfo != null && pathInfo.contains("customer");

        String startDateParam = StringUtils.trimToEmpty(req.getParameter("startDate"));
        String endDateParam = StringUtils.trimToEmpty(req.getParameter("endDate"));
        boolean shouldValidate = triggeredByPost || "true".equals(req.getParameter("submitted"));

        req.setAttribute("startDate", startDateParam);
        req.setAttribute("endDate", endDateParam);

        if (StringUtils.isBlank(startDateParam) || StringUtils.isBlank(endDateParam)) {
            if (shouldValidate) {
                req.setAttribute("error", "Vui lòng chọn khoảng thời gian hợp lệ.");
            }
            forwardToList(req, resp);
            return;
        }

        try {
            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);

            if (endDate.isBefore(startDate)) {
                req.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu.");
                forwardToList(req, resp);
                return;
            }

            List<CustomerRevenue> revenueList = orderDAO.calculateCustomerRevenue(startDate, endDate);
            req.setAttribute("customerRevenue", revenueList);

            if (detailView) {
                handleDetailView(req, resp, startDate, endDate, revenueList);
                return;
            }

            forwardToList(req, resp);
        } catch (DateTimeParseException e) {
            req.setAttribute("error", "Định dạng ngày không hợp lệ.");
            forwardToList(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Không thể tạo báo cáo doanh thu", e);
        }
    }

    private void handleDetailView(HttpServletRequest req, HttpServletResponse resp,
                                  LocalDate startDate, LocalDate endDate,
                                  List<CustomerRevenue> revenueList)
            throws ServletException, IOException {
        String customerIdParam = req.getParameter("customerId");
        if (StringUtils.isBlank(customerIdParam)) {
            req.setAttribute("error", "Vui lòng chọn khách hàng cần xem chi tiết.");
            forwardToList(req, resp);
            return;
        }

        try {
            Long customerId = Long.valueOf(customerIdParam);
            CustomerRevenue summary = revenueList.stream()
                    .filter(item -> item.getCustomerId().equals(customerId))
                    .findFirst()
                    .orElse(null);

            if (summary == null) {
                req.setAttribute("error", "Không tìm thấy khách hàng trong khoảng thời gian đã chọn.");
                forwardToList(req, resp);
                return;
            }

            List<Order> customerOrders = orderDAO.findByCustomerAndDateRange(customerId, startDate, endDate);
            req.setAttribute("selectedCustomerOrders", customerOrders);
            req.setAttribute("selectedCustomerId", customerId);
            req.setAttribute("selectedCustomerName", summary.getCustomerName());
            req.setAttribute("selectedCustomerOrderCount", summary.getOrderCount());

            BigDecimal total = summary.getRevenue() != null
                    ? summary.getRevenue()
                    : calculateTotalRevenue(customerOrders);
            req.setAttribute("selectedCustomerTotal", total);

            req.getRequestDispatcher("/jsp/customer_detail.jsp").forward(req, resp);
        } catch (NumberFormatException ex) {
            req.setAttribute("error", "Mã khách hàng không hợp lệ.");
            forwardToList(req, resp);
        } catch (SQLException sqlEx) {
            throw new ServletException("Không thể tải lịch sử giao dịch của khách hàng", sqlEx);
        }
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }

    private BigDecimal calculateTotalRevenue(List<Order> orders) {
        return orders.stream()
                .map(Order::getTotalAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
