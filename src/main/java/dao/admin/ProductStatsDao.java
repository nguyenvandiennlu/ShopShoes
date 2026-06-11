package dao.admin;

import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class ProductStatsDao {

    private final Jdbi jdbi = JDBIConnector.getJdbi();

    public List<Map<String, Object>> getTopSellingProducts(LocalDateTime start, LocalDateTime end, int limit) {
        String sql = """
                SELECT
                    p.id                        AS productId,
                    p.name                      AS productName,
                    b.name                      AS brandName,
                    pmi.img_url                 AS imgUrl,
                    COALESCE(SUM(od.quantity),0) AS totalSold,
                    COALESCE(SUM(od.subtotal),0) AS totalRevenue,
                    (SELECT COALESCE(SUM(pv2.stock),0)
                     FROM product_variant pv2
                     WHERE pv2.product_id = p.id
                       AND pv2.is_discontinue_variant = 0) AS totalStock
                FROM product p
                JOIN brand b ON b.id = p.brand_id
                LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
                LEFT JOIN order_detail od ON od.product_id = p.id
                LEFT JOIN orders o ON o.id = od.order_id
                    AND o.order_status IN ('COMPLETED','DELIVERED')
                    AND o.created_at BETWEEN :start AND :end
                WHERE p.is_available = 1
                  AND p.is_discontinue = 0
                GROUP BY p.id, p.name, b.name, pmi.img_url
                HAVING totalSold > 0
                ORDER BY totalSold DESC
                LIMIT :limit
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("start", start)
                .bind("end", end)
                .bind("limit", limit)
                .mapToMap()
                .list());
    }

    public List<Map<String, Object>> getUnsoldProducts(LocalDateTime start, LocalDateTime end, int limit) {
        String sql = """
                SELECT
                    p.id                        AS productId,
                    p.name                      AS productName,
                    b.name                      AS brandName,
                    pmi.img_url                 AS imgUrl,
                    0                           AS totalSold,
                    0                           AS totalRevenue,
                    (SELECT COALESCE(SUM(pv2.stock),0)
                     FROM product_variant pv2
                     WHERE pv2.product_id = p.id
                       AND pv2.is_discontinue_variant = 0) AS totalStock
                FROM product p
                JOIN brand b ON b.id = p.brand_id
                LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
                WHERE p.is_available = 1
                  AND p.is_discontinue = 0
                  AND NOT EXISTS (
                      SELECT 1 FROM order_detail od
                      JOIN orders o ON o.id = od.order_id
                      WHERE od.product_id = p.id
                        AND o.order_status IN ('COMPLETED','DELIVERED')
                        AND o.created_at BETWEEN :start AND :end
                  )
                ORDER BY totalStock DESC
                LIMIT :limit
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("start", start)
                .bind("end", end)
                .bind("limit", limit)
                .mapToMap()
                .list());
    }

    public List<Map<String, Object>> getLowStockProducts(int limit) {
        String sql = """
                SELECT
                    p.id                                    AS productId,
                    p.name                                  AS productName,
                    b.name                                  AS brandName,
                    pmi.img_url                             AS imgUrl,
                    COUNT(pv.id)                            AS variantCount,
                    SUM(pv.stock)                           AS totalStock,
                    SUM(CASE WHEN pv.stock = 0 THEN 1 ELSE 0 END)  AS outOfStockVariants,
                    SUM(CASE WHEN pv.stock > 0 AND pv.stock <= 5 THEN 1 ELSE 0 END) AS lowStockVariants
                FROM product p
                JOIN brand b ON b.id = p.brand_id
                LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
                JOIN product_variant pv ON pv.product_id = p.id
                    AND pv.is_discontinue_variant = 0
                WHERE p.is_available = 1
                  AND p.is_discontinue = 0
                GROUP BY p.id, p.name, b.name, pmi.img_url
                HAVING outOfStockVariants > 0 OR lowStockVariants > 0
                ORDER BY totalStock ASC, outOfStockVariants DESC
                LIMIT :limit
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("limit", limit)
                .mapToMap()
                .list());
    }
}