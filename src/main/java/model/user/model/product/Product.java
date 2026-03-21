package model.user.model.product;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Product implements Serializable {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;

    @ColumnName("brand_id")
    private int brandId;

    @ColumnName("added_at")
    private LocalDateTime addedAt;

    @ColumnName("is_discontinue")
    private boolean discontinue;

    @ColumnName("is_available")
    private boolean available;

    public Product() {
    }

    public Product(int id, String name, String description, BigDecimal price, int brandId, LocalDateTime addedAt,
            boolean discontinue, boolean available) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.brandId = brandId;
        this.addedAt = addedAt;
        this.discontinue = discontinue;
        this.available = available;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }

    public boolean isDiscontinue() {
        return discontinue;
    }

    public void setDiscontinue(boolean discontinue) {
        this.discontinue = discontinue;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}
