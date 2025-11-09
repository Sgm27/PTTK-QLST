package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.User;
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
 * Data access layer for {@link User} entities focused on authentication flows.
 */
public class UserDAO {

    private final CustomerDAO customerDAO = new CustomerDAO();

    public Optional<User> findByUsername(String username) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                    + "FROM tblUsers WHERE username = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        return Optional.of(mapRow(resultSet));
                    }
                }
            }
            return Optional.empty();
        }
    }

    public Optional<User> findByEmail(String email) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                    + "FROM tblUsers WHERE email = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, email);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        return Optional.of(mapRow(resultSet));
                    }
                }
            }
            return Optional.empty();
        }
    }

    /**
     * Persist a new customer account including the associated customer profile in a single transaction.
     */
    public void createCustomerAccount(User user, Customer customer) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                String userId = insertUser(connection, user);
                customer.setUserAccountId(userId);
                customerDAO.save(connection, customer);
                connection.commit();
            } catch (SQLException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        }
    }

    private String insertUser(Connection connection, User user) throws SQLException {
        String sql = "INSERT INTO tblUsers (username, password_hash, role, full_name, email, phone_number, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        LocalDateTime createdAt = user.getCreatedAt();
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
            user.setCreatedAt(createdAt);
        }
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getRole());
            statement.setString(4, user.getFullName());
            statement.setString(5, user.getEmail());
            statement.setString(6, user.getPhoneNumber());
            statement.setTimestamp(7, Timestamp.valueOf(createdAt));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    String id = keys.getString(1); // Changed to getString for VARCHAR ID
                    user.setId(id);
                    return id;
                }
            }
        }
        throw new SQLException("Không thể lấy mã người dùng sau khi tạo tài khoản.");
    }

    private User mapRow(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getString("id")); 
        user.setUsername(resultSet.getString("username"));
        user.setPasswordHash(resultSet.getString("password_hash"));
        user.setRole(resultSet.getString("role"));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhoneNumber(resultSet.getString("phone_number"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        return user;
    }
}
