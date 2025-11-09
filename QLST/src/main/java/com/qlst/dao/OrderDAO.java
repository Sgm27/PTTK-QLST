package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.Order;
import com.qlst.model.OrderDetail;
import com.qlst.model.Product;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Loads orders for a specific customer in a given period including their line items.
 */
public class OrderDAO extends DAO {

    private static final String ORDER_LIST_SQL =
            "SELECT o.id AS order_id, o.order_date, o.total_price, "
                    + "c.id AS customer_id, c.full_name, c.email, c.phone_number, c.address "
                    + "FROM tblOrders o "
                    + "JOIN tblCustomers c ON o.customer_id = c.id "
                    + "WHERE o.customer_id = ? AND o.order_date >= ? AND o.order_date < ? "
                    + "ORDER BY o.order_date DESC, o.id DESC";

    private static final String ORDER_DETAIL_SQL =
            "SELECT o.id AS order_id, o.order_date, o.total_price, "
                    + "c.id AS customer_id, c.full_name, c.email, c.phone_number, c.address, "
                    + "od.quantity AS order_detail_quantity, od.price AS order_detail_price, "
                    + "p.id AS product_id, p.name AS product_name, p.price AS product_price, p.quantity AS product_stock_quantity "
                    + "FROM tblOrders o "
                    + "JOIN tblCustomers c ON o.customer_id = c.id "
                    + "LEFT JOIN tblOrderDetails od ON od.order_id = o.id "
                    + "LEFT JOIN tblProducts p ON od.product_id = p.id "
                    + "WHERE o.id = ? "
                    + "ORDER BY od.order_id";

    public List<Order> getOrderList(String customerId, Date startDate, Date endDate) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement(ORDER_LIST_SQL)) {
            statement.setString(1, customerId);
            statement.setTimestamp(2, toStartOfDay(startDate));
            statement.setTimestamp(3, toStartOfNextDay(endDate));
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Order order = mapOrder(resultSet);
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public Order getOrderDetail(String orderId) throws SQLException {
        Order order = null;
        try (PreparedStatement statement = con.prepareStatement(ORDER_DETAIL_SQL)) {
            statement.setString(1, orderId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    if (order == null) {
                        order = mapOrder(resultSet);
                    }

                    String productId = resultSet.getString("product_id");
                    if (productId != null && !resultSet.wasNull()) {
                        OrderDetail detail = mapOrderDetail(resultSet);
                        detail.setOrder(order);
                        order.getListOrderDetail().add(detail);
                    }
                }
            }
        }
        return order;
    }

    private Order mapOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();
        order.setId(resultSet.getString("order_id")); 
        Timestamp timestamp = resultSet.getTimestamp("order_date");
        if (timestamp != null) {
            order.setDate(new Date(timestamp.getTime()));
        }
        BigDecimal totalPrice = resultSet.getBigDecimal("total_price");
        order.setTotalPrice(totalPrice != null ? totalPrice.floatValue() : 0F);
        order.setCustomer(mapCustomer(resultSet));
        return order;
    }

    private OrderDetail mapOrderDetail(ResultSet resultSet) throws SQLException {
        OrderDetail detail = new OrderDetail();
        // Note: OrderDetail no longer has an id field

        BigDecimal linePrice = resultSet.getBigDecimal("order_detail_price");
        if (linePrice != null) {
            detail.setPrice(linePrice.floatValue());
        }
        detail.setQuantity(resultSet.getInt("order_detail_quantity"));

        String productId = resultSet.getString("product_id"); // Changed to getString
        if (productId != null && !resultSet.wasNull()) {
            Product product = new Product();
            product.setId(productId); 
            product.setName(resultSet.getString("product_name"));

            BigDecimal productPrice = resultSet.getBigDecimal("product_price");
            if (productPrice != null) {
                product.setPrice(productPrice.floatValue());
            }
            Integer stockQuantity = getNullableInt(resultSet, "product_stock_quantity");
            if (stockQuantity != null) {
                product.setQuantity(stockQuantity);
            }

            detail.setProduct(product);
        }

        return detail;
    }

    private Customer mapCustomer(ResultSet resultSet) throws SQLException {
        Customer customer = new Customer();
        customer.setId(resultSet.getString("customer_id")); 
        customer.setName(resultSet.getString("full_name"));
        customer.setEmail(resultSet.getString("email"));
        customer.setPhone(resultSet.getString("phone_number"));
        customer.setAddress(resultSet.getString("address"));
        return customer;
    }

    private Timestamp toStartOfDay(Date date) {
        LocalDate localDate = Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        return Timestamp.valueOf(localDate.atStartOfDay());
    }

    private Timestamp toStartOfNextDay(Date date) {
        LocalDate nextDay = Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate()
                .plusDays(1);
        return Timestamp.valueOf(nextDay.atStartOfDay());
    }

    private Integer getNullableInt(ResultSet resultSet, String columnLabel) throws SQLException {
        Object value = resultSet.getObject(columnLabel);
        if (value == null) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        throw new SQLException("Expected numeric value for column '" + columnLabel + "' but found: " + value.getClass());
    }

    public float sumTotalPrice(List<Order> orders) {
        float total = 0F;
        if (orders != null) {
            for (Order order : orders) {
                total += order.getTotalPrice();
            }
        }
        return total;
    }
}
