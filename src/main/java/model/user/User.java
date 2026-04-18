package model.user;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.io.Serializable;
import java.time.LocalDateTime;
import enums.Role;

public class User implements Serializable {

    private int id;
    private String email;

    @ColumnName("password_hash")
    private String passwordHash;

    @ColumnName("phone_number")
    private String phoneNumber;

    private String address;
    // 'user', 'admin'
    private Role role;

    @ColumnName("full_name")
    private String fullName;

    @ColumnName("is_active")
    private boolean isActive;

    @ColumnName("created_at")
    private LocalDateTime createdAt;

    @ColumnName("firebase_uid")
    private String firebaseUID;

    @ColumnName("email_verified")
    private boolean emailVerified;

    public User() {

    }

    public int getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public Role getRole() {
        return role;
    }

    public String getFullName() {
        return fullName;
    }

    public boolean isActive() {
        return isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getFirebaseUID() {
        return firebaseUID;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setFirebaseUID(String firebaseUID) {
        this.firebaseUID = firebaseUID;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }
}
