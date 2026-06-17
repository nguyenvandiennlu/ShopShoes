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

    public List<Promotion> findAll() {
        String sql = """
            SELECT *
            FROM promotion
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
            return Collections.emptyList();
        }
    }

    public Promotion findById(int id) {
        String sql = """
            SELECT *
            FROM promotion
            WHERE id = :id
        """;
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(Promotion.class)
                            .findOne()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int insert(Promotion promo, List<Integer> productIds) {
        String insertPromoSql = """
            INSERT INTO promotion (name, slug, discount_type, discount_value, start_date, end_date, is_active)
            VALUES (:name, :slug, :discount_type, :discount_value, :start_date, :end_date, :is_active)
        """;
        
        String insertPromoProductSql = """
            INSERT INTO promotion_product (promotion_id, product_id)
            VALUES (:promotion_id, :product_id)
        """;

        try {
            return jdbi.inTransaction(handle -> {
                int promoId = handle.createUpdate(insertPromoSql)
                        .bind("name", promo.getName())
                        .bind("slug", promo.getSlug())
                        .bind("discount_type", promo.getDiscountType())
                        .bind("discount_value", promo.getDiscountValue())
                        .bind("start_date", promo.getStartDate())
                        .bind("end_date", promo.getEndDate())
                        .bind("is_active", promo.isActive())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one();

                if (productIds != null && !productIds.isEmpty()) {
                    var batch = handle.prepareBatch(insertPromoProductSql);
                    for (int productId : productIds) {
                        batch.bind("promotion_id", promoId)
                             .bind("product_id", productId)
                             .add();
                    }
                    batch.execute();
                }
                return promoId;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean update(Promotion promo, List<Integer> productIds) {
        String updatePromoSql = """
            UPDATE promotion
            SET name = :name,
                slug = :slug,
                discount_type = :discount_type,
                discount_value = :discount_value,
                start_date = :start_date,
                end_date = :end_date,
                is_active = :is_active
            WHERE id = :id
        """;

        String deletePromoProductsSql = """
            DELETE FROM promotion_product
            WHERE promotion_id = :promotion_id
        """;

        String insertPromoProductSql = """
            INSERT INTO promotion_product (promotion_id, product_id)
            VALUES (:promotion_id, :product_id)
        """;

        try {
            jdbi.useTransaction(handle -> {
                handle.createUpdate(updatePromoSql)
                        .bind("id", promo.getId())
                        .bind("name", promo.getName())
                        .bind("slug", promo.getSlug())
                        .bind("discount_type", promo.getDiscountType())
                        .bind("discount_value", promo.getDiscountValue())
                        .bind("start_date", promo.getStartDate())
                        .bind("end_date", promo.getEndDate())
                        .bind("is_active", promo.isActive())
                        .execute();

                handle.createUpdate(deletePromoProductsSql)
                        .bind("promotion_id", promo.getId())
                        .execute();

                if (productIds != null && !productIds.isEmpty()) {
                    var batch = handle.prepareBatch(insertPromoProductSql);
                    for (int productId : productIds) {
                        batch.bind("promotion_id", promo.getId())
                             .bind("product_id", productId)
                             .add();
                    }
                    batch.execute();
                }
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int promotionId) {
        String deletePromoProductSql = """
            DELETE FROM promotion_product
            WHERE promotion_id = :promotion_id
        """;
        
        String deletePromoSql = """
            DELETE FROM promotion
            WHERE id = :id
        """;

        try {
            jdbi.useTransaction(handle -> {
                handle.createUpdate(deletePromoProductSql)
                        .bind("promotion_id", promotionId)
                        .execute();

                handle.createUpdate(deletePromoSql)
                        .bind("id", promotionId)
                        .execute();
            });
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleActive(int promotionId, boolean isActive) {
        String sql = """
            UPDATE promotion
            SET is_active = :is_active
            WHERE id = :id
        """;
        try {
            int updated = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", promotionId)
                            .bind("is_active", isActive)
                            .execute()
            );
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> getLinkedProductIds(int promotionId) {
        String sql = """
            SELECT product_id
            FROM promotion_product
            WHERE promotion_id = :promotion_id
        """;
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("promotion_id", promotionId)
                            .mapTo(Integer.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

}

