package com.qlst.dto;

import java.math.BigDecimal;

/**
 * Represents aggregated revenue information for a customer within a period.
 */
public class CustomerRevenue {
    private final Long customerId;
    private final String customerName;
    private final BigDecimal revenue;
    private final Long transactionCount;

    public CustomerRevenue(Long customerId, String customerName, BigDecimal revenue, Long transactionCount) {
        this.customerId = customerId;
        this.customerName = customerName;
        this.revenue = revenue;
        this.transactionCount = transactionCount;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public Long getTransactionCount() {
        return transactionCount;
    }
}
