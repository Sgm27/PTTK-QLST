package com.qlst.dao;

import com.qlst.entity.Supplier;
import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data access layer for {@link Supplier} entities.
 */
public class SupplierDAO {

    public List<Supplier> findAll() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, name, contact_name, email, phone, address, notes FROM suppliers ORDER BY name";
            List<Supplier> suppliers = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    suppliers.add(mapRow(resultSet));
                }
            }
            return suppliers;
        }
    }

    public Optional<Supplier> findById(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT id, name, contact_name, email, phone, address, notes FROM suppliers WHERE id = ?";
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

    public void save(Supplier supplier) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "INSERT INTO suppliers (name, contact_name, email, phone, address, notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                statement.setString(1, supplier.getName());
                statement.setString(2, supplier.getContactName());
                statement.setString(3, supplier.getEmail());
                statement.setString(4, supplier.getPhone());
                statement.setString(5, supplier.getAddress());
                statement.setString(6, supplier.getNotes());
                statement.executeUpdate();
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        supplier.setId(keys.getLong(1));
                    }
                }
            }
        }
    }

    public void update(Supplier supplier) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE suppliers SET name = ?, contact_name = ?, email = ?, phone = ?, address = ?, notes = ? "
                    + "WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, supplier.getName());
                statement.setString(2, supplier.getContactName());
                statement.setString(3, supplier.getEmail());
                statement.setString(4, supplier.getPhone());
                statement.setString(5, supplier.getAddress());
                statement.setString(6, supplier.getNotes());
                statement.setLong(7, supplier.getId());
                statement.executeUpdate();
            }
        }
    }

    public void delete(Long id) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            String sql = "DELETE FROM suppliers WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, id);
                statement.executeUpdate();
            }
        }
    }

    private Supplier mapRow(ResultSet resultSet) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setId(resultSet.getLong("id"));
        supplier.setName(resultSet.getString("name"));
        supplier.setContactName(resultSet.getString("contact_name"));
        supplier.setEmail(resultSet.getString("email"));
        supplier.setPhone(resultSet.getString("phone"));
        supplier.setAddress(resultSet.getString("address"));
        supplier.setNotes(resultSet.getString("notes"));
        return supplier;
    }
}
