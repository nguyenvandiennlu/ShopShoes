package model.user.model.user;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.time.LocalDateTime;

public class Newsletter
{
    private int id;
    private String email;

    @ColumnName("is_active")
    private boolean isActive;

    @ColumnName("subscribed_at")
    private LocalDateTime subscribedAt;

    public Newsletter () { }

    public Newsletter (int id, String email, boolean isActive, LocalDateTime subscribedAt)
    {
        this.id = id;
        this.email = email;
        this.isActive = isActive;
        this.subscribedAt = subscribedAt;
    }
    public Integer getId() { return id; }
    public String getEmail() { return email;}
    public boolean isActive() { return isActive;}
    public LocalDateTime getSubscribedAt () { return subscribedAt; }

    public void setId(int id) { this.id = id; }
    public void setEmail(String email) { this.email = email; }
    public void setActive(boolean active) { this.isActive = active; }
    public void setSubscribedAt(LocalDateTime subscribedAt) { this.subscribedAt = subscribedAt; }

}
