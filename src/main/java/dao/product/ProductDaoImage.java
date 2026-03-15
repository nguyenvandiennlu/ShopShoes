package dao.product;

import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.ProductImage;
import model.product.ProductMainImage;

public class ProductDaoImage {

    private final Jdbi jdbi;

    public ProductDaoImage() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public ProductMainImage findMainImage(int productId) {

        String sql = """
        SELECT mi.*
        FROM product_main_img mi
        JOIN product p ON mi.product_id = p.id
        WHERE mi.product_id = :productId
          AND mi.is_active = 1
          AND p.is_available = 1
        LIMIT 1
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(ProductMainImage.class)
                            .findFirst()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ProductImage> findSubImages(int productId, int colorId) {

        String sql = """
        SELECT pi.*
        FROM product_img pi
        JOIN product p ON pi.product_id = p.id
        WHERE pi.product_id = :productId
          AND pi.color_id = :colorId
          AND pi.sort_order BETWEEN 1 AND 5
          AND pi.is_active = 1
          AND p.is_available = 1
        ORDER BY pi.sort_order ASC
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapToBean(ProductImage.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public ProductImage findMainColorImage(int productId, int colorId) {

        String sql = """
        SELECT pi.*
        FROM product_img pi
        JOIN product p ON pi.product_id = p.id
        WHERE pi.product_id = :productId
          AND pi.color_id = :colorId
          AND pi.sort_order = 0
          AND pi.is_active = 1
          AND p.is_available = 1
        LIMIT 1
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapToBean(ProductImage.class)
                            .findFirst()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
