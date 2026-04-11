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
    private int user_id;
    private String token;
    private LocalDateTime expiry_date;
    private LocalDateTime created_at;
    private String remember_token_id;
    private boolean is_active;
    private LocalDateTime invalidated_at;

    public RememberToken() {
    }

    public RememberToken(int user_id, String token, LocalDateTime expiry_date) {
        this.user_id = user_id;
        this.token = token;
        this.expiry_date = expiry_date;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiry_date() {
        return expiry_date;
    }

    public void setExpiry_date(LocalDateTime expiry_date) {
        this.expiry_date = expiry_date;
    }

    public LocalDateTime getCreatedAt() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public String getRemember_token_id() {
        return remember_token_id;
    }

    public void setRemember_token_id(String remember_token_id) {
        this.remember_token_id = remember_token_id;
    }

    public boolean isValid() {
        return is_active && expiry_date != null && LocalDateTime.now().isBefore(expiry_date);
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public LocalDateTime getInvalidated_at() {
        return invalidated_at;
    }

    public void setInvalidated_at(LocalDateTime invalidated_at) {
        this.invalidated_at = invalidated_at;
    }

    @Override
    public String toString() {
        return "RememberToken{" +
                "id=" + id +
                ", user_id=" + user_id +
                ", token='" + (token != null ? token.substring(0, Math.min(10, token.length())) + "..." : "null") + '\'' +
                ", expiry_date=" + expiry_date +
                ", created_at=" + created_at +
                ", remember_token_id='" + remember_token_id + '\'' +
                ", is_active=" + is_active +
                ", invalidated_at=" + invalidated_at +
                '}';
    }
}
