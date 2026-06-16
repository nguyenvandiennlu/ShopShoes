package model.admin;

import java.math.BigDecimal;

public class InventoryProductRow {

    private int     productId;
    private String  productName;
    private BigDecimal price;
    private boolean available;
    private boolean discontinue;
    private int     brandId;
    private String  brandName;
    private String  mainImageUrl;
    private int     totalStock;

    public InventoryProductRow() {}

    public int getProductId()               { return productId; }
    public void setProductId(int v)         { this.productId = v; }

    public String getProductName()          { return productName; }
    public void setProductName(String v)    { this.productName = v; }

    public BigDecimal getPrice()            { return price; }
    public void setPrice(BigDecimal v)      { this.price = v; }

    public boolean isAvailable()            { return available; }
    public void setAvailable(boolean v)     { this.available = v; }

    public boolean isDiscontinue()          { return discontinue; }
    public void setDiscontinue(boolean v)   { this.discontinue = v; }

    public int getBrandId()                 { return brandId; }
    public void setBrandId(int v)           { this.brandId = v; }

    public String getBrandName()            { return brandName; }
    public void setBrandName(String v)      { this.brandName = v; }

    public String getMainImageUrl()         { return mainImageUrl; }
    public void setMainImageUrl(String v)   { this.mainImageUrl = v; }

    public int getTotalStock()              { return totalStock; }
    public void setTotalStock(int v)        { this.totalStock = v; }

    public String getStockStatus() {
        if (totalStock == 0)       return "outstock";
        if (totalStock <= 5)       return "lowstock";
        return "instock";
    }
}