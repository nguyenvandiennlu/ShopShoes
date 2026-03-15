package services.product;

import DTO.ProductDTO;
import dao.product.ProductDao;
import model.Promotion.PromotionResult;
import model.product.Product;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class ProductService {
    ProductDao productDao = new ProductDao();
    PromotionService promotionService = new PromotionService();
    ProductImgService productImgService = new ProductImgService();

    private ProductDTO mapToProductDTO(Product p) {

        boolean isNew = productDao.isNew(p.getId());

        PromotionResult pr =
                promotionService.calculateBestPromotion(p.getId());

        String finalPrice =
                promotionService.formatVND(pr.getFinalPrice());

        String price =
                promotionService.formatVND(p.getPrice());

        String mainImgURL =
                productImgService.getMainImg(p.getId());

        String discountValue =
                promotionService.getDiscountValueString(
                        pr.getBestPromotion()
                );

        return new ProductDTO(
                p.getId(),
                p.getName(),
                price,
                finalPrice,
                mainImgURL,
                discountValue,
                isNew
        );
    }

    private List<ProductDTO> mapToProductDTOList(List<Product> products) {
        List<ProductDTO> result = new ArrayList<>();
        for (Product p : products) {
            result.add(mapToProductDTO(p));
        }
        return result;
    }

    public List<ProductDTO> findTopCheapestProductsInPromotion(int limit) {

        List<Product> products =
                productDao.findProductsInPromotion();

        List<ProductDTO> result =
                mapToProductDTOList(products);

        result.sort(Comparator.comparing(ProductDTO::getFinalPrice));

        if (result.size() > limit) {
            return result.subList(0, limit);
        }

        return result;
    }

    public List<ProductDTO> getNewestByBrandLimit(int brandId, int limit) {

        List<Product> products =
                productDao.findNewestByBrandLimit(brandId, limit);

        return mapToProductDTOList(products);
    }

    public List<ProductDTO> getNewestProducts(int limit) {

        List<Product> products =
                productDao.getNewestProducts(limit);

        return mapToProductDTOList(products);
    }

    public ProductDTO getProductById(int id) {

        Product p = productDao.findById(id);

        if (p == null) {
            return null;
        }

        return mapToProductDTO(p);
    }

    public String getDes(int productId) {
        return productDao.getDes(productId);
    }

    public List<ProductDTO> getRelatedProduct(int productId, int limit) {

        Product currentProduct = productDao.findById(productId);

        if (currentProduct == null) {
            return Collections.emptyList();
        }
        List<Product> products =
                productDao.getRelatedProduct(
                        currentProduct.getId(),
                        currentProduct.getBrandId(),
                        currentProduct.getPrice(),
                        limit
                );

        return mapToProductDTOList(products);
    }





    public List<ProductDTO> getProductsPage(int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int limit = pageSize;
        int offset = (safePage - 1) * limit;

        List<Product> products = productDao.findActivePage(limit, offset);
        List<ProductDTO> result = new ArrayList<>();

        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());

            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew));
        }
        return result;
    }

    public int getTotalPages(int pageSize) {
        int total = productDao.countActive(); // ví dụ 100
        return (int) Math.ceil(total * 1.0 / pageSize); // 12 => 9 trang
    }

    public List<ProductDTO> searchProducts(String keyword, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int offset = (safePage - 1) * pageSize;
        List<Product> products = productDao.searchByName(keyword, pageSize, offset);
        List<ProductDTO> result = new ArrayList<>();
        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());
            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew));
        }
        return result;
    }

    public int getSearchTotalPages(String keyword, int pageSize) {
        int total = productDao.countSearchResults(keyword);
        return (int) Math.ceil(total * 1.0 / pageSize);
    }

    // Lọc sản phẩm theo nhiều tiêu chí
    public List<ProductDTO> filterProducts(String keyword, List<Integer> brandIds,
                                           List<Integer> sizeIds, List<Integer> colorIds,
                                           java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice,
                                           String sortBy, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int offset = (safePage - 1) * pageSize;

        List<Product> products = productDao.filterProducts(keyword, brandIds, sizeIds, colorIds,
                minPrice, maxPrice, sortBy, pageSize, offset);
        List<ProductDTO> result = new ArrayList<>();

        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());

            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew));
        }
        return result;
    }

    // Tính tổng số trang sau khi lọc
    public int getFilteredTotalPages(String keyword, List<Integer> brandIds,
                                     List<Integer> sizeIds, List<Integer> colorIds,
                                     java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice,
                                     int pageSize) {
        int total = productDao.countFilteredProducts(keyword, brandIds, sizeIds, colorIds, minPrice, maxPrice);
        return (int) Math.ceil(total * 1.0 / pageSize);
    }



}




