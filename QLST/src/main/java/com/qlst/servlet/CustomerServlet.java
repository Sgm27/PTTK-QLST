package com.qlst.servlet;

import com.qlst.dao.OrderDAO;
import com.qlst.entity.Order;
import com.qlst.entity.User;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Manages customer-specific interactions such as viewing order history.
 */
public class CustomerServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        try {
            List<Order> orders = orderDAO.findByCustomerId(currentUser.getId());
            req.setAttribute("customerOrders", orders);
            req.setAttribute("totalSpent", calculateTotal(orders));
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách đơn hàng", e);
        }
        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        User currentUser = (User) session.getAttribute("currentUser");
        try {
            List<Order> orders = orderDAO.findByCustomerId(currentUser.getId());
            String startDateParam = req.getParameter("startDate");
            String endDateParam = req.getParameter("endDate");

            if (StringUtils.isNotBlank(startDateParam) && StringUtils.isNotBlank(endDateParam)) {
                LocalDate startDate = LocalDate.parse(startDateParam);
                LocalDate endDate = LocalDate.parse(endDateParam);
                if (endDate.isBefore(startDate)) {
                    req.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu.");
                } else {
                    orders = orders.stream()
                            .filter(order -> order.getOrderDate() != null)
                            .filter(order -> {
                                LocalDate orderDate = order.getOrderDate().toLocalDate();
                                return !orderDate.isBefore(startDate) && !orderDate.isAfter(endDate);
                            })
                            .collect(Collectors.toList());
                    req.setAttribute("startDate", startDate);
                    req.setAttribute("endDate", endDate);
                }
            }

            req.setAttribute("customerOrders", orders);
            req.setAttribute("totalSpent", calculateTotal(orders));
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách đơn hàng", e);
        }
        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }

    private BigDecimal calculateTotal(List<Order> orders) {
        return orders.stream()
                .map(Order::getTotalAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
