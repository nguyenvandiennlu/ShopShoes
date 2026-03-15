package model.Promotion;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Promotion implements Serializable {
    private int id;
    private String name;
    private String slug;
    private String discount_type;
    private BigDecimal discount_value;
    private LocalDateTime start_date;
    private LocalDateTime end_date;
    private boolean is_active;

    public Promotion() {
    }

    public Promotion(int id, String name, String slug, String discount_type, BigDecimal discount_value, LocalDateTime start_date, LocalDateTime end_date, boolean is_active) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.discount_type = discount_type;
        this.discount_value = discount_value;
        this.start_date = start_date;
        this.end_date = end_date;
        this.is_active = is_active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDiscountType() {
        return discount_type;
    }

    public void setDiscountType(String discount_type) {
        this.discount_type = discount_type;
    }

    public BigDecimal getDiscountValue() {
        return discount_value;
    }

    public void setDiscountValue(BigDecimal discount_value) {
        this.discount_value = discount_value;
    }

    public LocalDateTime getStartDate() {
        return start_date;
    }

    public void setStartDate(LocalDateTime start_date) {
        this.start_date = start_date;
    }

    public LocalDateTime getEndDate() {
        return end_date;
    }

    public void setEndDate(LocalDateTime end_date) {
        this.end_date = end_date;
    }

    public boolean isActive() {
        return is_active;
    }

    public void setActive(boolean is_active) {
        this.is_active = is_active;
    }
}
