package model.admin;

public class InventoryVariantRow {
    private int    variantId;
    private int    productId;
    private int    sizeId;
    private String sizeName;
    private int    colorId;
    private String colorName;
    private String hexcode;
    private int    stock;
    private boolean isDiscontinued;

    public InventoryVariantRow() {}

    public int    getVariantId()           { return variantId; }
    public void   setVariantId(int v)      { this.variantId = v; }
    public int    getProductId()           { return productId; }
    public void   setProductId(int v)      { this.productId = v; }
    public int    getSizeId()              { return sizeId; }
    public void   setSizeId(int v)         { this.sizeId = v; }
    public String getSizeName()            { return sizeName; }
    public void   setSizeName(String v)    { this.sizeName = v; }
    public int    getColorId()             { return colorId; }
    public void   setColorId(int v)        { this.colorId = v; }
    public String getColorName()           { return colorName; }
    public void   setColorName(String v)   { this.colorName = v; }
    public String getHexcode()             { return hexcode; }
    public void   setHexcode(String v)     { this.hexcode = v; }
    public int    getStock()               { return stock; }
    public void   setStock(int v)          { this.stock = v; }
    public boolean getIsDiscontinued()     {return isDiscontinued;}
    public void setIsDiscontinued(boolean isDiscontinued) {this.isDiscontinued = isDiscontinued;}
}