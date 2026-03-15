package DTO;

import model.common.Banner;
import model.product.Brand;

import java.io.Serializable;
import java.util.List;

public class MenuDTO implements Serializable {
    private Banner bannerSpecialP;
    private List<ProductDTO> specialProduct;
    private List<Banner> bannerCollection;
    private List<Banner> bannerSlider;
    private List<Brand> brandList;
    private List<ProductDTO> newestProduct;

    public MenuDTO() {
    }

    public Banner getBannerSpecialP() {
        return bannerSpecialP;
    }

    public void setBannerSpecialP(Banner bannerSpecialP) {
        this.bannerSpecialP = bannerSpecialP;
    }

    public List<ProductDTO> getSpecialProduct() {
        return specialProduct;
    }

    public void setSpecialProduct(List<ProductDTO> specialProduct) {
        this.specialProduct = specialProduct;
    }

    public List<Banner> getBannerCollection() {
        return bannerCollection;
    }

    public void setBannerCollection(List<Banner> bannerCollection) {
        this.bannerCollection = bannerCollection;
    }

    public List<Banner> getBannerSlider() {
        return bannerSlider;
    }

    public void setBannerSlider(List<Banner> bannerSlider) {
        this.bannerSlider = bannerSlider;
    }

    public List<Brand> getBrandList() {
        return brandList;
    }

    public void setBrandList(List<Brand> brandList) {
        this.brandList = brandList;
    }

    public List<ProductDTO> getNewestProduct() {
        return newestProduct;
    }

    public void setNewestProduct(List<ProductDTO> newestProduct) {
        this.newestProduct = newestProduct;
    }
}
