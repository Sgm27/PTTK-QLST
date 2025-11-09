package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.CustomerStatistic;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Provides aggregated customer revenue statistics.
 */
public class CustomerStatisticDAO extends DAO {

    private static final String CUSTOMER_REVENUE_SQL =
            "SELECT c.id AS customer_id, c.full_name, c.email, c.phone_number, c.address, "
                    + "SUM(o.total_price) AS total_revenue "
                    + "FROM tblOrders o "
                    + "JOIN tblCustomers c ON o.customer_id = c.id "
                    + "WHERE o.order_date >= ? AND o.order_date < ? "
                    + "GROUP BY c.id, c.full_name, c.email, c.phone_number, c.address "
                    + "ORDER BY total_revenue DESC";

    public List<CustomerStatistic> getCustomerStatistic(Date startDate, Date endDate) throws SQLException {
        List<CustomerStatistic> statistics = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement(CUSTOMER_REVENUE_SQL)) {
            statement.setTimestamp(1, toStartOfDay(startDate));
            statement.setTimestamp(2, toStartOfNextDay(endDate));
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Customer customer = mapCustomer(resultSet);
                    float totalPrice = 0F;
                    BigDecimal revenue = resultSet.getBigDecimal("total_revenue");
                    if (revenue != null) {
                        totalPrice = revenue.floatValue();
                    }
                    statistics.add(new CustomerStatistic(customer, totalPrice));
                }
            }
        }
        return statistics;
    }

    private Customer mapCustomer(ResultSet resultSet) throws SQLException {
        Customer customer = new Customer();
        customer.setId(resultSet.getString("customer_id")); 
        customer.setName(resultSet.getString("full_name"));
        customer.setEmail(resultSet.getString("email"));
        customer.setPhone(resultSet.getString("phone_number"));
        customer.setAddress(resultSet.getString("address"));
        return customer;
    }

    private Timestamp toStartOfDay(Date date) {
        LocalDate localDate = Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        return Timestamp.valueOf(localDate.atStartOfDay());
    }

    private Timestamp toStartOfNextDay(Date date) {
        LocalDate nextDay = Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate()
                .plusDays(1);
        return Timestamp.valueOf(nextDay.atStartOfDay());
    }
}
