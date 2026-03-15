package dao.promotion;

import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.Promotion.Promotion;

public class PromotionDao {

    private final Jdbi jdbi;

    public PromotionDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public List<Promotion> findAllActive() {

        String sql = """
            SELECT *
            FROM promotion
            WHERE is_active = 1
              AND (start_date IS NULL OR start_date <= NOW())
              AND (end_date IS NULL OR end_date >= NOW())
            ORDER BY start_date DESC
        """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // ✅ List → emptyList
        }
    }

    public List<Promotion> findPromotionForProduct(int productId) {

        String sql = """
        SELECT p.*
        FROM promotion p
        JOIN promotion_product pp
            ON p.id = pp.promotion_id
        JOIN product pr
            ON pr.id = pp.product_id
        WHERE pr.id = :productId
          AND pr.is_available = 1
          AND p.is_active = 1
          AND (p.start_date IS NULL OR p.start_date <= NOW())
          AND (p.end_date IS NULL OR p.end_date >= NOW())
        ORDER BY p.start_date DESC
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

}
