package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.Member;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * Handles persistence flows for the member registration feature.
 */
public class MemberDAO extends DAO {

    private static final String INSERT_USER_SQL =
            "INSERT INTO tblUsers (username, password_hash, role, full_name, email, phone_number, created_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private final CustomerDAO customerDAO = new CustomerDAO();

    public MemberDAO() {
        super();
    }

    /**
     * Persist the supplied member information as a customer account.
     *
     * @return true when the transaction commits successfully.
     */
    public boolean saveInformation(Member member) throws SQLException {
        boolean originalAutoCommit = con.getAutoCommit();
        try {
            con.setAutoCommit(false);

            String userId = insertUser(member);
            Customer customer = toCustomer(member, userId);
            customerDAO.save(con, customer);

            con.commit();
            member.setId(customer.getId());
            return true;
        } catch (SQLException ex) {
            con.rollback();
            throw ex;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    private String insertUser(Member member) throws SQLException {
        LocalDateTime createdAt = LocalDateTime.now();
        try (PreparedStatement statement = con.prepareStatement(INSERT_USER_SQL)) {
            statement.setString(1, member.getName());
            statement.setString(2, member.getPassword());
            statement.setString(3, "CUSTOMER");
            statement.setString(4, member.getName());
            statement.setString(5, member.getEmail());
            statement.setString(6, member.getPhone());
            statement.setTimestamp(7, Timestamp.valueOf(createdAt));
            statement.executeUpdate();
        }
        return fetchUserIdByUsername(member.getName());
    }

    private Customer toCustomer(Member member, String userId) {
        Customer customer = new Customer();
        customer.setName(member.getName());
        customer.setEmail(member.getEmail());
        customer.setPhone(member.getPhone());
        customer.setAddress(member.getAddress());
        customer.setUserAccountId(userId);
        customer.setJoinedAt(LocalDateTime.now());
        return customer;
    }

    private String fetchUserIdByUsername(String username) throws SQLException {
        String sql = "SELECT id FROM tblUsers WHERE username = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getString("id");
                }
            }
        }
        throw new SQLException("Khong the lay ma nguoi dung sau khi tao thanh vien.");
    }
}
