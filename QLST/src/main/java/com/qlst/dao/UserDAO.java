package com.qlst.dao;

import com.qlst.entity.User;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link User} entities.
 */
public class UserDAO {

    public Optional<User> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                    + "FROM users WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, id);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        return Optional.of(mapRow(resultSet));
                    }
                }
            }
            return Optional.empty();
        }
    }

    public Optional<User> findByUsername(String username) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                    + "FROM users WHERE username = ?";
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
                    + "FROM users WHERE email = ?";
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

    public List<User> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, username, password_hash, role, full_name, email, phone_number, created_at "
                    + "FROM users ORDER BY created_at DESC";
            List<User> users = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    users.add(mapRow(resultSet));
                }
            }
            return users;
        }
    }

    public void save(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password_hash, role, full_name, email, phone_number, created_at) "
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
                        user.setId(keys.getLong(1));
                    }
                }
            }
        }
    }

    public void update(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE users SET username = ?, password_hash = ?, role = ?, full_name = ?, email = ?, "
                    + "phone_number = ? WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, user.getUsername());
                statement.setString(2, user.getPasswordHash());
                statement.setString(3, user.getRole());
                statement.setString(4, user.getFullName());
                statement.setString(5, user.getEmail());
                statement.setString(6, user.getPhoneNumber());
                statement.setLong(7, user.getId());
                statement.executeUpdate();
            }
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "DELETE FROM users WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, id);
                statement.executeUpdate();
            }
        }
    }

    private User mapRow(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getLong("id"));
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
