package dao.admin;

import DTO.ProductEditDTO;
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
        if (tokens.isEmpty()) return;
        if (tokens.size() == 1) {
            sql.append(" AND p.name LIKE :token0 ");
            return;
        }
        sql.append(" AND (");
        for (int i = 0; i < tokens.size(); i++) {
            if (i > 0) sql.append(" OR ");
            sql.append("p.name LIKE :token").append(i);
        }
        sql.append(") ");
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
            String visible,
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

        if ("visible".equals(visible))     sql.append(" AND p.is_available = 1 ");
        else if ("hidden".equals(visible)) sql.append(" AND p.is_available = 0 ");

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
            String stockStatus,
            String visible
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

        if ("visible".equals(visible))     inner.append(" AND p.is_available = 1 ");
        else if ("hidden".equals(visible)) inner.append(" AND p.is_available = 0 ");

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

    public List<InventoryVariantRow> findVariantsByProduct(int productId, boolean includeDiscontinued) {
        StringBuilder sql = new StringBuilder("""
        SELECT
            pv.id         AS variantId,
            pv.product_id AS productId,
            pv.size_id    AS sizeId,
            s.name        AS sizeName,
            pv.color_id   AS colorId,
            c.name        AS colorName,
            c.hexcode     AS hexcode,
            pv.stock      AS stock,
            pv.is_discontinue_variant AS isDiscontinued
        FROM product_variant pv
        JOIN size  s ON s.id = pv.size_id
        JOIN color c ON c.id = pv.color_id
        WHERE pv.product_id = :productId
    """);

        if (!includeDiscontinued) {
            sql.append(" AND pv.is_discontinue_variant = 0 \n");
        }

        sql.append(" ORDER BY s.sort_order ASC, c.id ASC");

        return jdbi.withHandle(h -> h.createQuery(sql.toString())
                .bind("productId", productId)
                .mapToBean(InventoryVariantRow.class)
                .list());
    }

    public ProductEditDTO findProductDetail(int productId) {
        String sql = """
            SELECT
                p.id            AS id,
                p.name          AS name,
                p.price         AS price,
                p.brand_id      AS brandId,
                b.name          AS brandName,
                p.is_available  AS available,
                pmi.img_url     AS mainImgUrl
            FROM product p
            JOIN brand b ON b.id = p.brand_id
            LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
            WHERE p.id = :productId
        """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("productId", productId)
                .mapToBean(ProductEditDTO.class)
                .findOne()
                .orElse(null));
    }

    public void updateProduct(int productId, String name, java.math.BigDecimal price,
                              int brandId, boolean isAvailable, String mainImgUrl) {
        jdbi.useHandle(h -> h.createUpdate("""
                UPDATE product
                SET name         = :name,
                    price        = :price,
                    brand_id     = :brandId,
                    is_available = :isAvailable
                WHERE id = :productId
                """)
                .bind("name",        name)
                .bind("price",       price)
                .bind("brandId",     brandId)
                .bind("isAvailable", isAvailable ? 1 : 0)
                .bind("productId",   productId)
                .execute());

        if (mainImgUrl != null && !mainImgUrl.isBlank()) {
            jdbi.useHandle(h -> h.createUpdate("""
                    INSERT INTO product_main_img (product_id, img_url, is_active)
                    VALUES (:productId, :imgUrl, 1)
                    ON DUPLICATE KEY UPDATE img_url = :imgUrl, is_active = 1
                    """)
                    .bind("productId", productId)
                    .bind("imgUrl",    mainImgUrl)
                    .execute());
        }
    }

    public void updateStock(int variantId, int productId, int qty) {
        String sql = """
        UPDATE product_variant 
        SET stock = stock + :qty 
        WHERE id = :variantId AND product_id = :productId
    """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("qty", qty)
                .bind("variantId", variantId)
                .bind("productId", productId)
                .execute());
    }

    public void updateVariantStatus(int variantId, boolean isDiscontinued) {
        String sql = "UPDATE product_variant SET is_discontinue_variant = :status WHERE id = :id";
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("status", isDiscontinued)
                .bind("id", variantId)
                .execute());
    }

    public boolean checkVariantExists(int productId, int colorId, int sizeId) {
        String sql = "SELECT COUNT(*) FROM product_variant WHERE product_id = :pId AND color_id = :cId AND size_id = :sId";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("pId", productId)
                .bind("cId", colorId)
                .bind("sId", sizeId)
                .mapTo(Integer.class)
                .one() > 0);
    }

    public void insertVariant(int productId, int colorId, int sizeId, int stock) {
        String sql = """
        INSERT INTO product_variant (product_id, color_id, size_id, stock, is_discontinue_variant)
        VALUES (:pId, :cId, :sId, :stock, 0)
    """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("pId", productId)
                .bind("cId", colorId)
                .bind("sId", sizeId)
                .bind("stock", stock)
                .execute());
    }

    public int getMaxSortOrder(int productId, int colorId) {
        String sql = "SELECT COALESCE(MAX(sort_order), 0) FROM product_img WHERE product_id = :pId AND color_id = :cId";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("pId", productId)
                .bind("cId", colorId)
                .mapTo(Integer.class)
                .one());
    }

    public void insertProductImage(int productId, int colorId, String imgUrl, int sortOrder) {
        String sql = """
        INSERT INTO product_img (product_id, color_id, img_url, sort_order, is_active)
        VALUES (:pId, :cId, :imgUrl, :sortOrder, 1)
    """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("pId", productId)
                .bind("cId", colorId)
                .bind("imgUrl", imgUrl)
                .bind("sortOrder", sortOrder)
                .execute());
    }
}