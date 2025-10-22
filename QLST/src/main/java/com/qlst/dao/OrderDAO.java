package com.qlst.dao;

import com.qlst.dto.CustomerRevenue;
import com.qlst.entity.Order;
import com.qlst.entity.OrderItem;
import com.qlst.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link Order} aggregates.
 */
public class OrderDAO {

    public List<Order> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, customer_id, status, order_date, total_amount, delivery_address, order_type "
                    + "FROM orders ORDER BY order_date DESC";
            List<Order> orders = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Order order = mapOrder(resultSet);
                    order.getItems().addAll(findItemsByOrderId(connection, order.getId()));
                    orders.add(order);
                }
            }
            return orders;
        }
    }

    public Optional<Order> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, customer_id, status, order_date, total_amount, delivery_address, order_type "
                    + "FROM orders WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, id);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        Order order = mapOrder(resultSet);
                        order.getItems().addAll(findItemsByOrderId(connection, order.getId()));
                        return Optional.of(order);
                    }
                }
            }
            return Optional.empty();
        }
    }

    public void save(Order order) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            boolean previousAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                String orderSql = "INSERT INTO orders (customer_id, status, order_date, total_amount, delivery_address, order_type) "
                        + "VALUES (?, ?, ?, ?, ?, ?)";
                if (order.getOrderDate() == null) {
                    order.setOrderDate(LocalDateTime.now());
                }
                if (order.getStatus() == null) {
                    order.setStatus("PENDING");
                }
                if (order.getOrderType() == null) {
                    order.setOrderType("ONLINE");
                }
                BigDecimal totalAmount = order.getTotalAmount();
                if (totalAmount == null || BigDecimal.ZERO.compareTo(totalAmount) >= 0) {
                    totalAmount = calculateOrderTotal(order);
                    order.setTotalAmount(totalAmount);
                }
                try (PreparedStatement orderStmt = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    orderStmt.setLong(1, order.getCustomerId());
                    orderStmt.setString(2, order.getStatus());
                    orderStmt.setTimestamp(3, Timestamp.valueOf(order.getOrderDate()));
                    orderStmt.setBigDecimal(4, totalAmount);
                    orderStmt.setString(5, order.getDeliveryAddress());
                    orderStmt.setString(6, order.getOrderType());
                    orderStmt.executeUpdate();
                    try (ResultSet keys = orderStmt.getGeneratedKeys()) {
                        if (keys.next()) {
                            order.setId(keys.getLong(1));
                        }
                    }
                }

                saveOrderItems(connection, order);
                connection.commit();
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(previousAutoCommit);
            }
        }
    }

    public void updateStatus(Long orderId, String status) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE orders SET status = ? WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, status);
                statement.setLong(2, orderId);
                statement.executeUpdate();
            }
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            boolean previousAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement itemStmt = connection.prepareStatement("DELETE FROM order_items WHERE order_id = ?")) {
                    itemStmt.setLong(1, id);
                    itemStmt.executeUpdate();
                }
                try (PreparedStatement orderStmt = connection.prepareStatement("DELETE FROM orders WHERE id = ?")) {
                    orderStmt.setLong(1, id);
                    orderStmt.executeUpdate();
                }
                connection.commit();
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(previousAutoCommit);
            }
        }
    }

    public List<Order> findByCustomerId(Long customerId) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, customer_id, status, order_date, total_amount, delivery_address, order_type "
                    + "FROM orders WHERE customer_id = ? ORDER BY order_date DESC";
            List<Order> orders = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, customerId);
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        Order order = mapOrder(resultSet);
                        order.getItems().addAll(findItemsByOrderId(connection, order.getId()));
                        orders.add(order);
                    }
                }
            }
            return orders;
        }
    }

    public List<Order> findByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, customer_id, status, order_date, total_amount, delivery_address, order_type "
                    + "FROM orders WHERE order_date BETWEEN ? AND ? ORDER BY order_date DESC";
            List<Order> orders = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setTimestamp(1, Timestamp.valueOf(startDate.atStartOfDay()));
                statement.setTimestamp(2, Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        Order order = mapOrder(resultSet);
                        order.getItems().addAll(findItemsByOrderId(connection, order.getId()));
                        orders.add(order);
                    }
                }
            }
            return orders;
        }
    }

    public List<Order> findByCustomerAndDateRange(Long customerId, LocalDate startDate, LocalDate endDate)
            throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, customer_id, status, order_date, total_amount, delivery_address, order_type "
                    + "FROM orders WHERE customer_id = ? AND order_date BETWEEN ? AND ? ORDER BY order_date DESC";
            List<Order> orders = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, customerId);
                statement.setTimestamp(2, Timestamp.valueOf(startDate.atStartOfDay()));
                statement.setTimestamp(3, Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        Order order = mapOrder(resultSet);
                        order.getItems().addAll(findItemsByOrderId(connection, order.getId()));
                        orders.add(order);
                    }
                }
            }
            return orders;
        }
    }

    public List<CustomerRevenue> calculateCustomerRevenue(LocalDate startDate, LocalDate endDate) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT o.customer_id, u.full_name, SUM(o.total_amount) AS revenue, COUNT(*) AS order_count "
                    + "FROM orders o JOIN users u ON o.customer_id = u.id "
                    + "WHERE o.order_date BETWEEN ? AND ? "
                    + "GROUP BY o.customer_id, u.full_name ORDER BY revenue DESC";
            List<CustomerRevenue> result = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setTimestamp(1, Timestamp.valueOf(startDate.atStartOfDay()));
                statement.setTimestamp(2, Timestamp.valueOf(endDate.atTime(LocalTime.MAX)));
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        result.add(new CustomerRevenue(
                                rs.getLong("customer_id"),
                                rs.getString("full_name"),
                                rs.getBigDecimal("revenue"),
                                rs.getLong("order_count")));
                    }
                }
            }
            return result;
        }
    }

    private Order mapOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();
        order.setId(resultSet.getLong("id"));
        order.setCustomerId(resultSet.getLong("customer_id"));
        order.setStatus(resultSet.getString("status"));
        Timestamp orderDate = resultSet.getTimestamp("order_date");
        if (orderDate != null) {
            order.setOrderDate(orderDate.toLocalDateTime());
        }
        order.setTotalAmount(resultSet.getBigDecimal("total_amount"));
        order.setDeliveryAddress(resultSet.getString("delivery_address"));
        order.setOrderType(resultSet.getString("order_type"));
        return order;
    }

    private List<OrderItem> findItemsByOrderId(Connection connection, Long orderId) throws SQLException {
        String sql = "SELECT id, order_id, product_id, quantity, unit_price FROM order_items WHERE order_id = ?";
        List<OrderItem> items = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, orderId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(resultSet.getLong("id"));
                    item.setOrderId(resultSet.getLong("order_id"));
                    item.setProductId(resultSet.getLong("product_id"));
                    item.setQuantity(resultSet.getInt("quantity"));
                    item.setUnitPrice(resultSet.getBigDecimal("unit_price"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private void saveOrderItems(Connection connection, Order order) throws SQLException {
        if (order.getItems().isEmpty()) {
            return;
        }
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (OrderItem item : order.getItems()) {
                statement.setLong(1, order.getId());
                statement.setLong(2, item.getProductId());
                statement.setInt(3, item.getQuantity());
                statement.setBigDecimal(4, item.getUnitPrice());
                statement.addBatch();
            }
            statement.executeBatch();
        }
    }

    private BigDecimal calculateOrderTotal(Order order) {
        return order.getItems().stream()
                .map(item -> {
                    BigDecimal price = item.getUnitPrice() == null ? BigDecimal.ZERO : item.getUnitPrice();
                    return price.multiply(BigDecimal.valueOf(item.getQuantity()));
                })
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
