package com.qlst.dto;

import java.math.BigDecimal;

/**
 * Represents aggregated revenue information for a customer within a period.
 */
public class CustomerRevenue {
    private final Long customerId;
    private final String customerName;
    private final BigDecimal revenue;
    private final Long orderCount;

    public CustomerRevenue(Long customerId, String customerName, BigDecimal revenue, Long orderCount) {
        this.customerId = customerId;
        this.customerName = customerName;
        this.revenue = revenue;
        this.orderCount = orderCount;
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

    public Long getOrderCount() {
        return orderCount;
    }
}
