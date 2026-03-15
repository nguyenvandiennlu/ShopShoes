package model.user;

import java.io.Serializable;
import java.time.LocalDateTime;

public class WishList implements Serializable {

    private int id;
    private int product_id;
    private int user_id;
    private LocalDateTime added_at;

    public WishList () {
    }

    public WishList (int id, int product_id, int user_id, LocalDateTime added_at) {
        this.id = id;
        this.product_id = product_id;
        this.user_id = user_id;
        this.added_at = added_at;
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

    public void setProductId(int productId) {
        this.product_id = productId;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int userId) {
        this.user_id = userId;
    }

    public LocalDateTime getAddedAt() {
        return added_at;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.added_at = addedAt;
    }

}
