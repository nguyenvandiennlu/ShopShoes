package services.product;

import DTO.ProductDetailDTO;
import dao.product.BrandDao;
import dao.product.ProductDaoImage;
import dao.product.ProductVariantDao;
import model.product.Color;
import model.product.ProductImage;
import model.product.Size;

import java.util.ArrayList;
import java.util.List;

public class ProductDetailService {

    private final ProductService productService = new ProductService();
    private final BrandDao brandDao = new BrandDao();
    private final ProductDaoImage productDaoImage = new ProductDaoImage();
    private final ProductVariantDao productVariantDao = new ProductVariantDao();

    public ProductDetailDTO buildProductDetailPage(
            int productId,
            Integer colorId,
            Integer sizeId
    ) {

        ProductDetailDTO dto = new ProductDetailDTO();

        dto.setProductDTO(productService.getProductById(productId));
        dto.setBrand(brandDao.findBrandOfProduct(productId));
        dto.setProductDes(productService.getDes(productId));

        List<Color> colors =
                productVariantDao.findColorsByProduct(productId);
        dto.setProductColorList(colors);

        if (colorId == null) {
            colorId = productVariantDao.findDefaultColorId(productId);
        }

        if (colorId == null) {
            dto.setProductSizeList(List.of());
            dto.setStock(0);
            dto.setProductImg(List.of());
            dto.setRelatedProduct(
                    productService.getRelatedProduct(productId, 4)
            );
            return dto;
        }
        if (sizeId != null) {
            boolean valid =
                    productVariantDao.existsProductVariant(
                            productId, colorId, sizeId
                    );
            if (!valid) {
                sizeId = null;
            }
        }
        List<Size> sizes =
                productVariantDao.findSizesByProductAndColor(productId, colorId);
        dto.setProductSizeList(sizes);

        if (sizeId == null) {
            dto.setStock(
                    productVariantDao.getTotalStockByColor(productId, colorId)
            );
        } else {
            dto.setStock(
                    productVariantDao.getStock(productId, colorId, sizeId)
            );
        }
        List<String> images = new ArrayList<>();

        ProductImage mainImage =
                productDaoImage.findMainColorImage(productId, colorId);
        if (mainImage != null) {
            images.add(mainImage.getImgUrl());
        }

        List<ProductImage> subImages =
                productDaoImage.findSubImages(productId, colorId);
        for (ProductImage img : subImages) {
            images.add(img.getImgUrl());
        }

        dto.setProductImg(images);

        dto.setRelatedProduct(
                productService.getRelatedProduct(productId, 4)
        );

        dto.setCurrentColorId(colorId);
        dto.setCurrentSizeId(sizeId);
        return dto;
    }
}
