package services.product;

import DTO.ProductDTO;
import dao.collection.CollectionDao;
import dao.collection.CollectionProductDao;
import dao.collection.CollectionRuleDao;
import dao.product.ProductDao;
import model.Collection.Collection;
import model.Promotion.PromotionResult;
import model.product.Product;

import java.util.ArrayList;
import java.util.List;
public class CollectionService {

    private final CollectionDao collectionDao;
    private final CollectionProductDao collectionProductDao;
    private final CollectionRuleDao collectionRuleDao;
    private final ProductDao productDao;
    private final PromotionService promotionService;
    private final ProductImgService productImgService;

    public CollectionService() {
        this.collectionDao = new CollectionDao();
        this.collectionProductDao = new CollectionProductDao();
        this.collectionRuleDao = new CollectionRuleDao();
        this.productDao = new ProductDao();
        this.promotionService = new PromotionService();
        this.productImgService = new ProductImgService();
    }

    /**
     * Tìm collection theo slug
     */
    public Collection findBySlug(String slug) {
        return collectionDao.findBySlug(slug);
    }

    /**
     * Tìm collection theo ID
     */
    public Collection findById(int id) {
        return collectionDao.findById(id);
    }

    /**
     * Lấy tất cả collection active
     */
    public List<Collection> findAllActive() {
        return collectionDao.findAllActive();
    }

    /**
     * Lấy sản phẩm trong collection (hỗ trợ cả AUTO và MANUAL)
     * 
     * @param collectionId ID của collection
     * @param ruleSetType  "AUTO" hoặc "MANUAL"
     * @return Danh sách ProductDTO
     */
    public List<ProductDTO> getProductsInCollection(int collectionId, String ruleSetType) {
        List<Product> products;

        if ("AUTO".equalsIgnoreCase(ruleSetType)) {
            // AUTO: Lấy sản phẩm dựa trên rules
            products = collectionRuleDao.getProductsByRules(collectionId, ruleSetType);
        } else {
            // MANUAL: Lấy sản phẩm từ bảng collection_product
            products = collectionProductDao.getProductsInCollection(collectionId);
        }

        return mapToProductDTOList(products);
    }

    /**
     * Lấy sản phẩm trong collection với phân trang
     */
    public List<ProductDTO> getProductsInCollectionPaged(int collectionId, String ruleSetType,
            int page, int pageSize) {
        int offset = (Math.max(page, 1) - 1) * pageSize;
        List<Product> products;

        if ("AUTO".equalsIgnoreCase(ruleSetType)) {
            products = collectionRuleDao.getProductsByRulesPaged(collectionId, ruleSetType, pageSize, offset);
        } else {
            products = collectionProductDao.getProductsInCollectionPaged(collectionId, pageSize, offset);
        }

        return mapToProductDTOList(products);
    }

    /**
     * Đếm số sản phẩm trong collection
     */
    public int countProductsInCollection(int collectionId, String ruleSetType) {
        if ("AUTO".equalsIgnoreCase(ruleSetType)) {
            return collectionRuleDao.countProductsByRules(collectionId, ruleSetType);
        } else {
            return collectionProductDao.countProductsInCollection(collectionId);
        }
    }

    /**
     * Tính số trang
     */
    public int getTotalPages(int collectionId, String ruleSetType, int pageSize) {
        int total = countProductsInCollection(collectionId, ruleSetType);
        return (int) Math.ceil(total * 1.0 / pageSize);
    }

    /**
     * Map Product entity sang ProductDTO
     */
    private ProductDTO mapToProductDTO(Product p) {
        boolean isNew = productDao.isNew(p.getId());

        PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
        String finalPrice = promotionService.formatVND(pr.getFinalPrice());
        String price = promotionService.formatVND(p.getPrice());
        String mainImgURL = productImgService.getMainImg(p.getId());
        String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());

        return new ProductDTO(
                p.getId(),
                p.getName(),
                price,
                finalPrice,
                mainImgURL,
                discountValue,
                isNew);
    }

    private List<ProductDTO> mapToProductDTOList(List<Product> products) {
        List<ProductDTO> result = new ArrayList<>();
        for (Product p : products) {
            result.add(mapToProductDTO(p));
        }
        return result;
    }
}
