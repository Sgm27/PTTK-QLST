package com.qlst.model;

/**
 * Aggregated revenue for a specific customer within a date range.
 */
public class CustomerStatistic {
    private float totalPrice;
    private Customer customer;

    public CustomerStatistic() {
    }

    public CustomerStatistic(Customer customer, float totalPrice) {
        this.customer = customer;
        this.totalPrice = totalPrice;
    }

    public float getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(float totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
}

