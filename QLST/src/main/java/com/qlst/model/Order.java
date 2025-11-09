package com.qlst.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Represents an order placed by a customer.
 */
public class Order {
    private String id; 
    private Date date;
    private float totalPrice;
    private Customer customer;
    private DeliveryInvoice deliveryInvoice;
    private List<OrderDetail> listOrderDetail = new ArrayList<>();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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

    public DeliveryInvoice getDeliveryInvoice() {
        return deliveryInvoice;
    }

    public void setDeliveryInvoice(DeliveryInvoice deliveryInvoice) {
        this.deliveryInvoice = deliveryInvoice;
    }

    public List<OrderDetail> getListOrderDetail() {
        return listOrderDetail;
    }

    public void setListOrderDetail(List<OrderDetail> listOrderDetail) {
        this.listOrderDetail = listOrderDetail;
    }
}

