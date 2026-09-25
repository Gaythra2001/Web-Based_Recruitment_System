package com.recruitment.model;

import java.sql.Timestamp;

/**
 * POJO representing a system user.
 * Maps to the 'users' table.
 */
public class User implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private int       userId;
    private String    firstName;
    private String    lastName;
    private String    email;
    private String    passwordHash;
    private String    role;           // JOB_SEEKER, EMPLOYER, ADMIN
    private String    phone;
    private String    accountStatus;  // ACTIVE, INACTIVE, SUSPENDED
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() {}

    // -- Getters --
    public int       getUserId()        { return userId; }
    public String    getFirstName()     { return firstName; }
    public String    getLastName()      { return lastName; }
    public String    getFullName()      { return firstName + " " + lastName; }
    public String    getEmail()         { return email; }
    public String    getPasswordHash()  { return passwordHash; }
    public String    getRole()          { return role; }
    public String    getPhone()         { return phone; }
    public String    getAccountStatus() { return accountStatus; }
    public Timestamp getCreatedAt()     { return createdAt; }
    public Timestamp getUpdatedAt()     { return updatedAt; }

    // -- Setters --
    public void setUserId(int userId)              { this.userId = userId; }
    public void setFirstName(String firstName)      { this.firstName = firstName; }
    public void setLastName(String lastName)        { this.lastName = lastName; }
    public void setEmail(String email)              { this.email = email; }
    public void setPasswordHash(String hash)        { this.passwordHash = hash; }
    public void setRole(String role)                { this.role = role; }
    public void setPhone(String phone)              { this.phone = phone; }
    public void setAccountStatus(String status)     { this.accountStatus = status; }
    public void setCreatedAt(Timestamp createdAt)   { this.createdAt = createdAt; }
    public void setUpdatedAt(Timestamp updatedAt)   { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", email='" + email + "', role='" + role + "'}";
    }
}
