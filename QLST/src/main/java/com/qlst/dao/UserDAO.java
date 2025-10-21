package com.qlst.dao;

import com.qlst.entity.User;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link User} entities.
 */
public class UserDAO {

    public Optional<User> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query
            return Optional.empty();
        }
    }

    public Optional<User> findByUsername(String username) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query
            return Optional.empty();
        }
    }

    public List<User> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query
            return new ArrayList<>();
        }
    }

    public void save(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement insert logic
            throw new UnsupportedOperationException("save not implemented yet");
        }
    }

    public void update(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement update logic
            throw new UnsupportedOperationException("update not implemented yet");
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement delete logic
            throw new UnsupportedOperationException("delete not implemented yet");
        }
    }
}
