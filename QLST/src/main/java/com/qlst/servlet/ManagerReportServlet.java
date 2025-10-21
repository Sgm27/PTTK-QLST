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
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Provides reporting views for managers.
 */
public class ManagerReportServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Order> orders = orderDAO.findAll();
            req.setAttribute("totalRevenue", calculateTotalRevenue(orders));
            req.setAttribute("ordersByStatus", aggregateByStatus(orders));
            req.setAttribute("recentOrders", orders.stream().limit(10).collect(Collectors.toList()));
            req.setAttribute("ordersCount", orders.size());
        } catch (SQLException e) {
            throw new ServletException("Không thể tải báo cáo", e);
        }
        req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String startDateParam = req.getParameter("startDate");
        String endDateParam = req.getParameter("endDate");

        if (StringUtils.isBlank(startDateParam) || StringUtils.isBlank(endDateParam)) {
            req.setAttribute("error", "Vui lòng chọn khoảng thời gian hợp lệ.");
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
                req.setAttribute("startDate", startDate);
                req.setAttribute("endDate", endDate);
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

    private Map<String, Long> aggregateByStatus(List<Order> orders) {
        return orders.stream()
                .collect(Collectors.groupingBy(order -> StringUtils.defaultIfBlank(order.getStatus(), "KHÁC"),
                        Collectors.counting()));
    }
}
