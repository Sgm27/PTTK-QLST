package com.qlst.dao;

import com.qlst.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Base DAO providing the shared JDBC connection handle.
 */
public class DAO implements AutoCloseable {
    protected Connection con;

    public DAO() {
        try {
            this.con = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot open database connection", e);
        }
    }

    @Override
    public void close() throws SQLException {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    }
}

