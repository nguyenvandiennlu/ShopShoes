package services.product;

import dao.product.ProductDaoImage;
import model.product.ProductMainImage;

public class ProductImgService {
    ProductDaoImage productDaoImage = new ProductDaoImage();

    public String getMainImg(int idP) {
        ProductMainImage productMainImage = productDaoImage.findMainImage(idP);
        if (productMainImage == null) {
            return "";
        }
        String mainImg = productMainImage.getImgUrl();
        return mainImg != null ? mainImg : "";
    }

}
