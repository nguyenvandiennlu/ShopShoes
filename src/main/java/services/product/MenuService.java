package services.product;

import DTO.MenuDTO;
import dao.product.BannerDao;
import dao.product.BrandDao;

public class MenuService {
    BannerDao bannerDao = new BannerDao(); // TODO: BannerDao not found
    ProductService productService = new ProductService();
    BrandDao brandDao = new BrandDao();

    public MenuDTO buildMenuPage(String brandId) {
        MenuDTO dto = new MenuDTO();
        dto.setBannerSpecialP(bannerDao.findByPosition("menu_special-product")); // TODO: BannerDao not found
        dto.setSpecialProduct(productService.findTopCheapestProductsInPromotion(9));
        dto.setBannerCollection(bannerDao.findByPositions("menu_collection")); // TODO: BannerDao not found
        dto.setBannerSlider(bannerDao.findByPositions("products_slide")); // TODO: BannerDao not found
        dto.setBrandList(brandDao.findAllActive());

        if ("all".equalsIgnoreCase(brandId)) {
            dto.setNewestProduct(productService.getNewestProducts(16));
        } else {
            int id = Integer.parseInt(brandId);
            dto.setNewestProduct(productService.getNewestByBrandLimit(id, 16));
        }
        return dto;
    }
}
