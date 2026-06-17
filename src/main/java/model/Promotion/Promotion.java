package model.Promotion;

import org.jdbi.v3.core.mapper.reflect.ColumnName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Promotion implements Serializable {
    private int id;
    private String name;
    private String slug;

    @ColumnName("discount_type")
    private String discountType;

    @ColumnName("discount_value")
    private BigDecimal discountValue;

    @ColumnName("start_date")
    private LocalDateTime startDate;

    @ColumnName("end_date")
    private LocalDateTime endDate;

    @ColumnName("is_active")
    private boolean isActive;

    public Promotion() {
    }

    public Promotion(int id, String name, String slug, String discount_type, BigDecimal discount_value, LocalDateTime start_date, LocalDateTime end_date, boolean is_active) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.discountType = discount_type;
        this.discountValue = discount_value;
        this.startDate = start_date;
        this.endDate = end_date;
        this.isActive = is_active;
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
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
}
