package dao.admin;

import dao.JDBIConnector;
import model.admin.InventoryProductRow;
import model.admin.InventoryVariantRow;
import org.jdbi.v3.core.Jdbi;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class InventoryDao {

    private final Jdbi jdbi = JDBIConnector.getJdbi();

    private List<String> tokenize(String keyword) {
        if (keyword == null || keyword.isBlank()) return List.of();
        return Arrays.stream(keyword.trim().split("\\s+"))
                .filter(t -> !t.isEmpty())
                .collect(Collectors.toList());
    }

    private void appendTokenConditions(StringBuilder sql, List<String> tokens) {
        for (int i = 0; i < tokens.size(); i++) {
            sql.append(" AND p.name LIKE :token").append(i).append(" ");
        }
    }

    private void bindTokens(org.jdbi.v3.core.statement.Query query, List<String> tokens) {
        for (int i = 0; i < tokens.size(); i++) {
            query.bind("token" + i, "%" + tokens.get(i) + "%");
        }
    }

    public List<InventoryProductRow> findWithFilter(
            String keyword,
            Integer brandId,
            Integer colorId,
            Integer sizeId,
            String stockStatus,
            int limit,
            int offset
    ) {
        List<String> tokens = tokenize(keyword);

        StringBuilder sql = new StringBuilder("""
            SELECT
                p.id             AS productId,
                p.name           AS productName,
                p.price          AS price,
                p.is_available   AS available,
                p.is_discontinue AS discontinue,
                b.id             AS brandId,
                b.name           AS brandName,
                pmi.img_url      AS mainImageUrl,
                COALESCE(SUM(pv.stock), 0) AS totalStock
            FROM product p
            JOIN brand b ON p.brand_id = b.id
            LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
            LEFT JOIN product_variant pv
                ON pv.product_id = p.id
               AND pv.is_discontinue_variant = 0
            WHERE p.is_discontinue = 0
        """);

        appendTokenConditions(sql, tokens);

        if (brandId != null) sql.append(" AND p.brand_id = :brandId ");
        if (colorId != null) sql.append("""
            AND EXISTS (SELECT 1 FROM product_variant pv2
                        WHERE pv2.product_id = p.id
                          AND pv2.color_id = :colorId
                          AND pv2.is_discontinue_variant = 0)
        """);
        if (sizeId != null) sql.append("""
            AND EXISTS (SELECT 1 FROM product_variant pv3
                        WHERE pv3.product_id = p.id
                          AND pv3.size_id = :sizeId
                          AND pv3.is_discontinue_variant = 0)
        """);

        sql.append(" GROUP BY p.id, p.name, p.price, p.is_available, p.is_discontinue, b.id, b.name, pmi.img_url ");

        if ("instock".equals(stockStatus))       sql.append(" HAVING totalStock > 5 ");
        else if ("lowstock".equals(stockStatus)) sql.append(" HAVING totalStock > 0 AND totalStock <= 5 ");
        else if ("outstock".equals(stockStatus)) sql.append(" HAVING totalStock = 0 ");

        sql.append(" ORDER BY p.added_at DESC, p.id DESC LIMIT :limit OFFSET :offset ");

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sql.toString());
            bindTokens(query, tokens);
            if (brandId != null) query.bind("brandId", brandId);
            if (colorId != null) query.bind("colorId", colorId);
            if (sizeId  != null) query.bind("sizeId",  sizeId);
            query.bind("limit", limit).bind("offset", offset);
            return query.mapToBean(InventoryProductRow.class).list();
        });
    }

    public int countWithFilter(
            String keyword,
            Integer brandId,
            Integer colorId,
            Integer sizeId,
            String stockStatus
    ) {
        List<String> tokens = tokenize(keyword);

        StringBuilder inner = new StringBuilder("""
            SELECT p.id, COALESCE(SUM(pv.stock), 0) AS totalStock
            FROM product p
            JOIN brand b ON p.brand_id = b.id
            LEFT JOIN product_variant pv
                ON pv.product_id = p.id
               AND pv.is_discontinue_variant = 0
            WHERE p.is_discontinue = 0
        """);

        appendTokenConditions(inner, tokens);

        if (brandId != null) inner.append(" AND p.brand_id = :brandId ");
        if (colorId != null) inner.append("""
            AND EXISTS (SELECT 1 FROM product_variant pv2
                        WHERE pv2.product_id = p.id
                          AND pv2.color_id = :colorId
                          AND pv2.is_discontinue_variant = 0)
        """);
        if (sizeId != null) inner.append("""
            AND EXISTS (SELECT 1 FROM product_variant pv3
                        WHERE pv3.product_id = p.id
                          AND pv3.size_id = :sizeId
                          AND pv3.is_discontinue_variant = 0)
        """);

        inner.append(" GROUP BY p.id ");

        if ("instock".equals(stockStatus))       inner.append(" HAVING totalStock > 5 ");
        else if ("lowstock".equals(stockStatus)) inner.append(" HAVING totalStock > 0 AND totalStock <= 5 ");
        else if ("outstock".equals(stockStatus)) inner.append(" HAVING totalStock = 0 ");

        String sql = "SELECT COUNT(*) FROM (" + inner + ") AS sub";

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sql);
            bindTokens(query, tokens);
            if (brandId != null) query.bind("brandId", brandId);
            if (colorId != null) query.bind("colorId", colorId);
            if (sizeId  != null) query.bind("sizeId",  sizeId);
            return query.mapTo(Integer.class).one();
        });
    }

    public List<InventoryVariantRow> findVariantsByProduct(int productId) {
        String sql = """
            SELECT
                pv.id         AS variantId,
                pv.product_id AS productId,
                pv.size_id    AS sizeId,
                s.name        AS sizeName,
                pv.color_id   AS colorId,
                c.name        AS colorName,
                c.hexcode     AS hexcode,
                pv.stock      AS stock
            FROM product_variant pv
            JOIN size  s ON s.id = pv.size_id
            JOIN color c ON c.id = pv.color_id
            WHERE pv.product_id = :productId
              AND pv.is_discontinue_variant = 0
            ORDER BY s.sort_order ASC, c.id ASC
        """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("productId", productId)
                .mapToBean(InventoryVariantRow.class)
                .list());
    }
}