package com.qlst.dao;

import com.qlst.entity.Customer;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Data access layer for {@link Customer} entities.
 */
public class CustomerDAO {

    public Optional<Customer> findByUserId(Long userId) throws SQLException {
        String sql = "SELECT id, user_id, full_name, email, phone_number, address, joined_at FROM customers WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
            }
            return Optional.empty();
        }
    }

    public Optional<Customer> findById(Long customerId) throws SQLException {
        String sql = "SELECT id, user_id, full_name, email, phone_number, address, joined_at FROM customers WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, customerId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
            }
            return Optional.empty();
        }
    }

    public void save(Connection connection, Customer customer) throws SQLException {
        String sql = "INSERT INTO customers (user_id, full_name, email, phone_number, address, joined_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        LocalDateTime joinedAt = customer.getJoinedAt();
        if (joinedAt == null) {
            joinedAt = LocalDateTime.now();
            customer.setJoinedAt(joinedAt);
        }
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, customer.getUserId());
            statement.setString(2, customer.getFullName());
            statement.setString(3, customer.getEmail());
            statement.setString(4, customer.getPhoneNumber());
            statement.setString(5, customer.getAddress());
            statement.setTimestamp(6, Timestamp.valueOf(joinedAt));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    customer.setId(keys.getLong(1));
                }
            }
        }
    }

    private Customer mapRow(ResultSet resultSet) throws SQLException {
        Customer customer = new Customer();
        customer.setId(resultSet.getLong("id"));
        customer.setUserId(resultSet.getLong("user_id"));
        customer.setFullName(resultSet.getString("full_name"));
        customer.setEmail(resultSet.getString("email"));
        customer.setPhoneNumber(resultSet.getString("phone_number"));
        customer.setAddress(resultSet.getString("address"));
        Timestamp joinedAt = resultSet.getTimestamp("joined_at");
        if (joinedAt != null) {
            customer.setJoinedAt(joinedAt.toLocalDateTime());
        }
        return customer;
    }
}
