package model.user.model.product;

import java.io.Serializable;

public class ProductVariant implements Serializable {
    private int id;
    private int product_id;
    private int size_id;
    private int color_id;
    private int stock;
    private boolean is_discontinue_variant;

    public ProductVariant() {
    }

    public ProductVariant(int id, int product_id, int size_id, int color_id, int stock, boolean is_discontinue_variant) {
        this.id = id;
        this.product_id = product_id;
        this.size_id = size_id;
        this.color_id = color_id;
        this.stock = stock;
        this.is_discontinue_variant = is_discontinue_variant;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return product_id;
    }

    public void setProductId(int product_id) {
        this.product_id = product_id;
    }

    public int getSizeId() {
        return size_id;
    }

    public void setSizeId(int size_id) {
        this.size_id = size_id;
    }

    public int getColorId() {
        return color_id;
    }

    public void setColorId(int color_id) {
        this.color_id = color_id;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public boolean isDiscontinueVariant() {
        return is_discontinue_variant;
    }

    public void setDiscontinueVariant(boolean is_discontinue_variant) {
        this.is_discontinue_variant = is_discontinue_variant;
    }
}
