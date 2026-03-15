package model.product;

import java.io.Serializable;

public class ProductMainImage implements Serializable {
    private int id;
    private int product_id;
    private String img_url;
    private boolean is_active;

    public ProductMainImage(int id, int product_id, String img_url, boolean is_active) {
        this.id = id;
        this.product_id = product_id;
        this.img_url = img_url;
        this.is_active = is_active;
    }

    public ProductMainImage() {
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

    public String getImgUrl() {
        return img_url;
    }

    public void setImgUrl(String img_url) {
        this.img_url = img_url;
    }

    public boolean isActive() {
        return is_active;
    }

    public void setActive(boolean is_active) {
        this.is_active = is_active;
    }
}

