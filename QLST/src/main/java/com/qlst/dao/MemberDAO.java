package com.qlst.dao;

import com.qlst.model.Customer;
import com.qlst.model.Member;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
        try (PreparedStatement statement = con.prepareStatement(INSERT_USER_SQL, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, member.getName());
            statement.setString(2, member.getPassword());
            statement.setString(3, "CUSTOMER");
            statement.setString(4, member.getName());
            statement.setString(5, member.getEmail());
            statement.setString(6, member.getPhone());
            statement.setTimestamp(7, Timestamp.valueOf(createdAt));
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getString(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã người dùng sau khi tạo thành viên.");
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
}
