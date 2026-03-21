package model.user.model.user;

import java.io.Serializable;

public class CartItem implements Serializable {

    private int productId;
    private int colorId;
    private int sizeId;

    private String name;
    private String image;
    private String colorName;
    private String sizeName;

    private String originalPrice;
    private String finalPrice;
    private String discountValue;
    private int quantity;

    public String getKey() {
        return productId + "-" + colorId + "-" + sizeId;
    }

    public CartItem() {
    }

    public CartItem(int productId, int colorId, int sizeId, String name, String image, String colorName, String sizeName, String originalPrice, String finalPrice, String discountValue, int quantity) {
        this.productId = productId;
        this.colorId = colorId;
        this.sizeId = sizeId;
        this.name = name;
        this.image = image;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.originalPrice = originalPrice;
        this.finalPrice = finalPrice;
        this.discountValue = discountValue;
        this.quantity = quantity;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getColorId() {
        return colorId;
    }

    public void setColorId(int colorId) {
        this.colorId = colorId;
    }

    public int getSizeId() {
        return sizeId;
    }

    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(String originalPrice) {
        this.originalPrice = originalPrice;
    }

    public String getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(String finalPrice) {
        this.finalPrice = finalPrice;
    }

    public String getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(String discountValue) {
        this.discountValue = discountValue;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}