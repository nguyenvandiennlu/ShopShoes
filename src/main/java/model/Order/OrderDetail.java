package model.Order;

import java.io.Serializable;
import java.math.BigDecimal;

public class OrderDetail implements Serializable {

    private int id;
    private int order_id;
    private int product_id;
    private int color_id;
    private int size_id;

    private int quantity;
    private BigDecimal unit_price;
    private BigDecimal subtotal;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return order_id;
    }

    public void setOrderId(int order_id) {
        this.order_id = order_id;
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

    public int getSizeId() {
        return size_id;
    }

    public void setSizeId(int size_id) {
        this.size_id = size_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unit_price;
    }

    public void setUnitPrice(BigDecimal unit_price) {
        this.unit_price = unit_price;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}