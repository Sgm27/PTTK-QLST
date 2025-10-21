package com.qlst.dao;

import com.qlst.entity.Order;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link Order} aggregates.
 */
public class OrderDAO {

    public List<Order> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query with items
            return new ArrayList<>();
        }
    }

    public Optional<Order> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query with items
            return Optional.empty();
        }
    }

    public void save(Order order) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement insert logic
            throw new UnsupportedOperationException("save not implemented yet");
        }
    }

    public void updateStatus(Long orderId, String status) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement update logic
            throw new UnsupportedOperationException("updateStatus not implemented yet");
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement delete logic
            throw new UnsupportedOperationException("delete not implemented yet");
        }
    }
}
