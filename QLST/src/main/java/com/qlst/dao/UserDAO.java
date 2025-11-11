package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Data access layer for {@link User} entities focused on authentication flows.
 */
public class UserDAO extends DAO {

    private final CustomerDAO customerDAO = new CustomerDAO();

    public UserDAO() {
        super();
    }

    public Optional<User> findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                + "FROM tblUsers WHERE username = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public Optional<User> findByEmail(String email) throws SQLException {
        String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                + "FROM tblUsers WHERE email = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public Optional<User> findByPhoneNumber(String phoneNumber) throws SQLException {
        String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                + "FROM tblUsers WHERE phone_number = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, phoneNumber);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public void validateUniqueness(String phoneNumber, String email, java.util.List<String> errors) throws SQLException {
        if (findByPhoneNumber(phoneNumber).isPresent()) {
            errors.add("So dien thoai da duoc su dung. Vui long chon so khac.");
        }
        if (findByEmail(email).isPresent()) {
            errors.add("Email da duoc su dung.");
        }
    }

    /**
     * Persist a new customer account including the associated customer profile in a single transaction.
     */
    public void createCustomerAccount(User user, Customer customer) throws SQLException {
        boolean originalAutoCommit = con.getAutoCommit();
        con.setAutoCommit(false);
        try {
            String userId = insertUser(con, user);
            customer.setUserAccountId(userId);
            customerDAO.save(con, customer);
            con.commit();
        } catch (SQLException ex) {
            con.rollback();
            throw ex;
        } finally {
            con.setAutoCommit(originalAutoCommit);
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
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getRole());
            statement.setString(4, user.getFullName());
            statement.setString(5, user.getEmail());
            statement.setString(6, user.getPhoneNumber());
            statement.setTimestamp(7, Timestamp.valueOf(createdAt));
            statement.executeUpdate();
        }
        String id = resolveUserId(connection, user.getUsername());
        user.setId(id);
        return id;
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

    private String resolveUserId(Connection connection, String username) throws SQLException {
        String sql = "SELECT id FROM tblUsers WHERE username = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getString("id");
                }
            }
        }
        throw new SQLException("Can not retrieve user ID for username: " + username);
    }
}
