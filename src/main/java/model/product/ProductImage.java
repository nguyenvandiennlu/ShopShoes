package model.product;

import java.io.Serializable;

public class ProductImage implements Serializable {
    private int id;
    private int product_id;
    private int color_id;
    private String img_url;
    private boolean is_main;
    private int sort_order;
    private boolean is_active;

    public ProductImage() {
    }

    public ProductImage(int id, int product_id, int color_id, String img_url, int sort_order, boolean is_active) {
        this.id = id;
        this.product_id = product_id;
        this.color_id = color_id;
        this.img_url = img_url;
        this.sort_order = sort_order;
        this.is_active = is_active;
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

    public int getColorId() {
        return color_id;
    }

    public void setColorId(int color_id) {
        this.color_id = color_id;
    }

    public String getImgUrl() {
        return img_url;
    }

    public void setImgUrl(String img_url) {
        this.img_url = img_url;
    }

    public int getSortOrder() {
        return sort_order;
    }

    public void setSortOrder(int sort_order) {
        this.sort_order = sort_order;
    }

    public boolean isActive() {
        return is_active;
    }

    public void setActive(boolean is_active) {
        this.is_active = is_active;
    }
}
