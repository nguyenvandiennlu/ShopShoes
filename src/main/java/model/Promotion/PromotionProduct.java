package model.Promotion;

import java.io.Serializable;

public class PromotionProduct implements Serializable {
    private int promotion_id;
    private int product_id;

    public PromotionProduct() {
    }

    public PromotionProduct(int promotion_id, int product_id) {
        this.promotion_id = promotion_id;
        this.product_id = product_id;
    }

    public int getPromotionId() {
        return promotion_id;
    }

    public void setPromotionId(int promotion_id) {
        this.promotion_id = promotion_id;
    }

    public int getProductId() {
        return product_id;
    }

    public void setProductId(int product_id) {
        this.product_id = product_id;
    }
}
