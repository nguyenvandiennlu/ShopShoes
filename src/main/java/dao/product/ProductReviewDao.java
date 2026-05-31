package dao.product;

import dao.JDBIConnector;
import model.product.ProductReview;
import org.jdbi.v3.core.Jdbi;

import java.util.Collections;
import java.util.List;

public class ProductReviewDao {
    private final Jdbi jdbi = JDBIConnector.getJdbi();

    public void insertReview(ProductReview review) {
        String sql = """
            INSERT INTO product_review (product_id, user_id, rating, content, is_verified_purchase)
            VALUES (:productId, :userId, :rating, :content, :verifiedPurchase)
        """;

        try {
            jdbi.useHandle(h -> h.createUpdate(sql)
                    .bindBean(review)
                    .execute());
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi thêm đánh giá vào CSDL");
        }
    }

    public List<ProductReview> getReviewsByProductId(int productId) {
        String sql = """
            SELECT 
                id, 
                product_id AS productId, 
                user_id AS userId, 
                rating, 
                content, 
                created_at AS createdAt, 
                is_verified_purchase AS verifiedPurchase
            FROM product_review
            WHERE product_id = :productId
            ORDER BY created_at DESC
        """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(ProductReview.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}