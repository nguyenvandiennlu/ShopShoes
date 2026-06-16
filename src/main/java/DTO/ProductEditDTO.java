package DTO;

import java.math.BigDecimal;

public class ProductEditDTO {
    private int        id;
    private String     name;
    private BigDecimal price;
    private int        brandId;
    private String     brandName;
    private boolean    available;
    private String     mainImgUrl;

    public ProductEditDTO() {}

    public int        getId()                   { return id; }
    public void       setId(int v)              { this.id = v; }
    public String     getName()                 { return name; }
    public void       setName(String v)         { this.name = v; }
    public BigDecimal getPrice()                { return price; }
    public void       setPrice(BigDecimal v)    { this.price = v; }
    public int        getBrandId()              { return brandId; }
    public void       setBrandId(int v)         { this.brandId = v; }
    public String     getBrandName()            { return brandName; }
    public void       setBrandName(String v)    { this.brandName = v; }
    public boolean    isAvailable()             { return available; }
    public void       setAvailable(boolean v)   { this.available = v; }
    public String     getMainImgUrl()           { return mainImgUrl; }
    public void       setMainImgUrl(String v)   { this.mainImgUrl = v; }
}