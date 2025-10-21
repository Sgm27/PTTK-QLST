package com.qlst.dao;

import com.qlst.entity.Product;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link Product} entities.
 */
public class ProductDAO {

    public List<Product> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query
            return new ArrayList<>();
        }
    }

    public Optional<Product> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement select query
            return Optional.empty();
        }
    }

    public void save(Product product) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            // TODO: Implement insert logic
            throw new UnsupportedOperationException("save not implemented yet");
        }
    }

    public void update(Product product) throws SQLException {
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
