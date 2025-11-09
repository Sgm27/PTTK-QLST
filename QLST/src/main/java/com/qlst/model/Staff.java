package com.qlst.model;

/**
 * Represents a staff member of the supermarket.
 */
public class Staff extends Member {
    private String position;

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}

