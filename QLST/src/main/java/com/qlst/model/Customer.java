package com.qlst.model;

import java.time.LocalDateTime;

/**
 * Represents a customer whose revenue is analysed.
 */
public class Customer extends Member {
    // The id attribute is inherited from Member; included explicitly in the specification.
    private String userAccountId; 
    private LocalDateTime joinedAt;

    public String getUserAccountId() {
        return userAccountId;
    }

    public void setUserAccountId(String userAccountId) {
        this.userAccountId = userAccountId;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }
}
