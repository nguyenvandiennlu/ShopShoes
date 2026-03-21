package model.user.model.Collection;

import java.io.Serializable;

public class CollectionProduct implements Serializable {
    private int id;
    private int collection_id;
    private int product_id;
    private int sort_order;

    public CollectionProduct() {
    }

    public CollectionProduct(int id, int collection_id, int product_id, int sort_order) {
        this.id = id;
        this.collection_id = collection_id;
        this.product_id = product_id;
        this.sort_order = sort_order;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCollectionId() {
        return collection_id;
    }

    public void setCollectionId(int collection_id) {
        this.collection_id = collection_id;
    }

    public int getProductId() {
        return product_id;
    }

    public void setProductId(int product_id) {
        this.product_id = product_id;
    }

    public int getSortOrder() {
        return sort_order;
    }

    public void setSortOrder(int sort_order) {
        this.sort_order = sort_order;
    }
}
