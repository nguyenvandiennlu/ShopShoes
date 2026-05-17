package dao.cart;

import java.math.BigDecimal;

public class CartItemRow {
    private int id;
    private int cartId;
    private int productId;
    private int colorId;
    private int sizeId;
    private int quantity;
    private BigDecimal unitPrice;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getColorId() { return colorId; }
    public void setColorId(int colorId) { this.colorId = colorId; }

    public int getSizeId() { return sizeId; }
    public void setSizeId(int sizeId) { this.sizeId = sizeId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}
