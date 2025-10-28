package com.qlst.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Represents a financial transaction made by a customer.
 */
public class Transaction {
    private Long id;
    private Long customerId;
    private BigDecimal amount;
    private LocalDateTime transactionDate;
    private String description;

    public Transaction() {
    }

    public Transaction(Long id, Long customerId, BigDecimal amount,
                       LocalDateTime transactionDate, String description) {
        this.id = id;
        this.customerId = customerId;
        this.amount = amount;
        this.transactionDate = transactionDate;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
