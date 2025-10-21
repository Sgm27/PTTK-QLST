package com.qlst.dao;

import com.qlst.entity.Product;
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
 * Data access layer for {@link Product} entities.
 */
public class ProductDAO {

    public List<Product> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, name, sku, description, unit_price, stock_quantity, supplier_id, category, "
                    + "created_at, updated_at FROM products ORDER BY created_at DESC";
            List<Product> products = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    products.add(mapRow(resultSet));
                }
            }
            return products;
        }
    }

    public Optional<Product> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, name, sku, description, unit_price, stock_quantity, supplier_id, category, "
                    + "created_at, updated_at FROM products WHERE id = ?";
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

    public void save(Product product) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "INSERT INTO products (name, sku, description, unit_price, stock_quantity, supplier_id, "
                    + "category, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            LocalDateTime now = LocalDateTime.now();
            if (product.getCreatedAt() == null) {
                product.setCreatedAt(now);
            }
            product.setUpdatedAt(now);
            try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                statement.setString(1, product.getName());
                statement.setString(2, product.getSku());
                statement.setString(3, product.getDescription());
                statement.setBigDecimal(4, product.getUnitPrice());
                statement.setInt(5, product.getStockQuantity());
                if (product.getSupplierId() != null) {
                    statement.setLong(6, product.getSupplierId());
                } else {
                    statement.setNull(6, java.sql.Types.BIGINT);
                }
                statement.setString(7, product.getCategory());
                statement.setTimestamp(8, Timestamp.valueOf(product.getCreatedAt()));
                statement.setTimestamp(9, Timestamp.valueOf(product.getUpdatedAt()));
                statement.executeUpdate();
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        product.setId(keys.getLong(1));
                    }
                }
            }
        }
    }

    public void update(Product product) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE products SET name = ?, sku = ?, description = ?, unit_price = ?, stock_quantity = ?, "
                    + "supplier_id = ?, category = ?, updated_at = ? WHERE id = ?";
            LocalDateTime updatedAt = LocalDateTime.now();
            product.setUpdatedAt(updatedAt);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, product.getName());
                statement.setString(2, product.getSku());
                statement.setString(3, product.getDescription());
                statement.setBigDecimal(4, product.getUnitPrice());
                statement.setInt(5, product.getStockQuantity());
                if (product.getSupplierId() != null) {
                    statement.setLong(6, product.getSupplierId());
                } else {
                    statement.setNull(6, java.sql.Types.BIGINT);
                }
                statement.setString(7, product.getCategory());
                statement.setTimestamp(8, Timestamp.valueOf(updatedAt));
                statement.setLong(9, product.getId());
                statement.executeUpdate();
            }
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, id);
                statement.executeUpdate();
            }
        }
    }

    private Product mapRow(ResultSet resultSet) throws SQLException {
        Product product = new Product();
        product.setId(resultSet.getLong("id"));
        product.setName(resultSet.getString("name"));
        product.setSku(resultSet.getString("sku"));
        product.setDescription(resultSet.getString("description"));
        product.setUnitPrice(resultSet.getBigDecimal("unit_price"));
        product.setStockQuantity(resultSet.getInt("stock_quantity"));
        long supplierId = resultSet.getLong("supplier_id");
        if (!resultSet.wasNull()) {
            product.setSupplierId(supplierId);
        }
        product.setCategory(resultSet.getString("category"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toLocalDateTime());
        }
        Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return product;
    }
}
