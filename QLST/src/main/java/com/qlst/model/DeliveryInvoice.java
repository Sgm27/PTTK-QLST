package com.qlst.model;

import java.util.Date;

/**
 * Placeholder implementation representing a delivery invoice associated with an order.
 * The full implementation belongs to another module; here we only keep the structure required by the specification.
 */
public class DeliveryInvoice {
    private int id;
    private Date deliveryDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    }
}

