package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.Order;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Data access layer for {@link Customer} profiles.
 */
public class CustomerDAO {

    public void save(Connection connection, Customer customer) throws SQLException {
        if (customer.getUserAccountId() == null) {
            throw new IllegalArgumentException("Customer must have an associated user account id before saving.");
        }
        String sql = "INSERT INTO tblCustomers (user_id, full_name, email, phone_number, address, joined_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        LocalDateTime joinedAt = customer.getJoinedAt();
        if (joinedAt == null) {
            joinedAt = LocalDateTime.now();
            customer.setJoinedAt(joinedAt);
        }
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, customer.getUserAccountId()); 
            statement.setString(2, customer.getName());

            statement.setString(3, customer.getEmail());
            statement.setString(4, customer.getPhone());
            statement.setString(5, customer.getAddress());
            statement.setTimestamp(6, Timestamp.valueOf(joinedAt));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    customer.setId(keys.getString(1)); 
                }
            }
        }
    }

    public Customer resolveCustomer(String customerId, List<Order> orders) {
        if (orders != null && !orders.isEmpty() && orders.get(0).getCustomer() != null) {
            return orders.get(0).getCustomer();
        }
        Customer customer = new Customer();
        customer.setId(customerId);
        return customer;
    }
}
