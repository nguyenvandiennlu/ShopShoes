package DTO;

import model.product.Brand;
import model.product.Color;
import model.product.Size;

import java.io.Serializable;
import java.util.List;

public class ProductDetailDTO implements Serializable {
    private ProductDTO productDTO;
    private Brand brand;
    private String productDes;
    private List<Color> productColorList;
    private List<Size> productSizeList;
    private int stock;
    private List<String> productImg;
    private List<ProductDTO> relatedProduct;
    private Integer currentColorId;
    private Integer currentSizeId;

    public ProductDetailDTO() {
    }

    public ProductDTO getProductDTO() {
        return productDTO;
    }

    public void setProductDTO(ProductDTO productDTO) {
        this.productDTO = productDTO;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public String getProductDes() {
        return productDes;
    }

    public void setProductDes(String productDes) {
        this.productDes = productDes;
    }

    public List<Color> getProductColorList() {
        return productColorList;
    }

    public void setProductColorList(List<Color> productColorList) {
        this.productColorList = productColorList;
    }

    public List<Size> getProductSizeList() {
        return productSizeList;
    }

    public void setProductSizeList(List<Size> productSizeList) {
        this.productSizeList = productSizeList;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public List<String> getProductImg() {
        return productImg;
    }

    public void setProductImg(List<String> productImg) {
        this.productImg = productImg;
    }

    public List<ProductDTO> getRelatedProduct() {
        return relatedProduct;
    }

    public void setRelatedProduct(List<ProductDTO> relatedProduct) {
        this.relatedProduct = relatedProduct;
    }

    public Integer getCurrentColorId() {
        return currentColorId;
    }

    public void setCurrentColorId(Integer currentColorId) {
        this.currentColorId = currentColorId;
    }

    public Integer getCurrentSizeId() {
        return currentSizeId;
    }

    public void setCurrentSizeId(Integer currentSizeId) {
        this.currentSizeId = currentSizeId;
    }
}
