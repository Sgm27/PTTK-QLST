package com.qlst.dao;

import com.qlst.dto.CustomerRevenue;
import com.qlst.entity.Transaction;
import com.qlst.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Provides database access for customer revenue statistics.
 */
public class StatisticsDAO {

    public List<CustomerRevenue> calculateCustomerRevenue(LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = "SELECT c.id AS customer_id, c.full_name, SUM(t.amount) AS revenue, COUNT(*) AS transaction_count "
                + "FROM transactions t "
                + "JOIN customers c ON t.customer_id = c.id "
                + "WHERE t.transaction_date >= ? AND t.transaction_date < ? "
                + "GROUP BY c.id, c.full_name "
                + "ORDER BY revenue DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setTimestamp(1, Timestamp.valueOf(startDate.atStartOfDay()));
            statement.setTimestamp(2, Timestamp.valueOf(endDate.plusDays(1).atStartOfDay()));
            List<CustomerRevenue> results = new ArrayList<>();
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    results.add(new CustomerRevenue(
                            rs.getLong("customer_id"),
                            rs.getString("full_name"),
                            rs.getBigDecimal("revenue"),
                            rs.getLong("transaction_count")));
                }
            }
            return results;
        }
    }

    public List<Transaction> findTransactionsByCustomerAndDateRange(Long customerId, LocalDate startDate, LocalDate endDate)
            throws SQLException {
        String sql = "SELECT id, customer_id, amount, transaction_date, description "
                + "FROM transactions WHERE customer_id = ? AND transaction_date >= ? AND transaction_date < ? "
                + "ORDER BY transaction_date DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, customerId);
            statement.setTimestamp(2, Timestamp.valueOf(startDate.atStartOfDay()));
            statement.setTimestamp(3, Timestamp.valueOf(endDate.plusDays(1).atStartOfDay()));
            List<Transaction> transactions = new ArrayList<>();
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapTransaction(rs));
                }
            }
            return transactions;
        }
    }

    private Transaction mapTransaction(ResultSet resultSet) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setId(resultSet.getLong("id"));
        transaction.setCustomerId(resultSet.getLong("customer_id"));
        transaction.setAmount(resultSet.getBigDecimal("amount"));
        Timestamp transactionDate = resultSet.getTimestamp("transaction_date");
        if (transactionDate != null) {
            transaction.setTransactionDate(transactionDate.toLocalDateTime());
        }
        transaction.setDescription(resultSet.getString("description"));
        return transaction;
    }

    public BigDecimal calculateTotal(List<Transaction> transactions) {
        return transactions.stream()
                .map(Transaction::getAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
