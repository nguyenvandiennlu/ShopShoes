package model.user;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Model đại diện cho token nhớ tài khoản
 * Lưu trữ thông tin xác thực người dùng dài hạn
 */
public class RememberToken implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String tokenHash;
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isActive;

    // Constructors
    public RememberToken() {
    }

    public RememberToken(int userId, String tokenHash, LocalDateTime expiresAt) {
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public void setTokenHash(String tokenHash) {
        this.tokenHash = tokenHash;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    /**
     * Kiểm tra token có hết hạn không
     */
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }

    /**
     * Kiểm tra token có hợp lệ không (chưa hết hạn và đang active)
     */
    public boolean isValid() {
        return isActive && !isExpired();
    }

    @Override
    public String toString() {
        return "RememberToken{" +
                "id=" + id +
                ", userId=" + userId +
                ", tokenHash='" + tokenHash + '\'' +
                ", expiresAt=" + expiresAt +
                ", isActive=" + isActive +
                '}';
    }
}
