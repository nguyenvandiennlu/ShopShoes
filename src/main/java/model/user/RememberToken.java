package model.user;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

public class RememberToken implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String token;
    private LocalDateTime expiryDate;
    private LocalDateTime createdAt;
    private String rememberTokenId;
    private boolean active;
    private LocalDateTime invalidatedAt;

    public RememberToken() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    @ColumnName("user_id")
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiryDate() {
        return expiryDate;
    }

    @ColumnName("expiry_date")
    public void setExpiryDate(LocalDateTime expiryDate) {
        this.expiryDate = expiryDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    @ColumnName("created_at")
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getRememberTokenId() {
        return rememberTokenId;
    }
    @ColumnName("remember_token_id")
    public void setRememberTokenId(String rememberTokenId) {
        this.rememberTokenId = rememberTokenId;
    }

    public boolean isActive() {
        return active;
    }

    @ColumnName("is_active")
    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getInvalidatedAt() {
        return invalidatedAt;
    }

    @ColumnName("invalidated_at")
    public void setInvalidatedAt(LocalDateTime invalidatedAt) {
        this.invalidatedAt = invalidatedAt;
    }

    public boolean isValid() {
        return active && expiryDate != null && LocalDateTime.now().isBefore(expiryDate);
    }
}