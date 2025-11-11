package com.qlst.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Objects;
import java.util.Properties;

/**
 * Base DAO providing the shared JDBC connection handle.
 */
public class DAO implements AutoCloseable {
    private static final String PROPERTIES_FILE = "db.properties";
    private static final Properties PROPERTIES = new Properties();

    static {
        loadProperties();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL driver not found: " + e.getMessage());
        }
    }

    protected Connection con;

    public DAO() {
        try {
            this.con = getConnection();
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot open database connection", e);
        }
    }

    private static void loadProperties() {
        try (InputStream input = Thread.currentThread()
                .getContextClassLoader()
                .getResourceAsStream(PROPERTIES_FILE)) {
            if (Objects.isNull(input)) {
                throw new IllegalStateException("Cannot find database configuration: " + PROPERTIES_FILE);
            }
            PROPERTIES.load(input);
        } catch (IOException e) {
            throw new ExceptionInInitializerError("Failed to load database properties: " + e.getMessage());
        }
    }

    private static Connection getConnection() throws SQLException {
        String host = PROPERTIES.getProperty("db.host");
        String port = PROPERTIES.getProperty("db.port");
        String database = PROPERTIES.getProperty("db.database");
        String user = PROPERTIES.getProperty("db.user");
        String password = PROPERTIES.getProperty("db.password");

        String url = String.format("jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC", host, port, database);
        return DriverManager.getConnection(url, user, password);
    }

    @Override
    public void close() throws SQLException {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    }
}

