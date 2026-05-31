package model.product;

import java.time.LocalDateTime;

public class ProductReview {
    private int id;
    private int productId;
    private int userId;
    private int rating;
    private String content;
    private LocalDateTime createdAt;
    private boolean verifiedPurchase;

    public ProductReview() {
    }

    public ProductReview(int productId, int userId, int rating, String content, boolean verifiedPurchase) {
        this.productId = productId;
        this.userId = userId;
        this.rating = rating;
        this.content = content;
        this.verifiedPurchase = verifiedPurchase;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isVerifiedPurchase() {
        return verifiedPurchase;
    }

    public void setVerifiedPurchase(boolean verifiedPurchase) {
        this.verifiedPurchase = verifiedPurchase;
    }
}