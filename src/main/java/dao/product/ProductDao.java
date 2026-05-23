package dao.product;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Product;

public class ProductDao {

    private final Jdbi jdbi;

    public ProductDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public Product findById(int id) {
        String sql = "SELECT * FROM product WHERE id = :id";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("id", id)
                .mapToBean(Product.class)
                .findOne()
                .orElse(null));
    }

    public List<Product> findAllActive() {
        String sql = """
                    SELECT * FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                    ORDER BY added_at DESC
                """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .mapToBean(Product.class)
                .list());
    }

    public void insert(Product product) {
        String sql = """
                    INSERT INTO product(name, description, price, brand_id,
                                        added_at, is_discontinue, is_available)
                    VALUES(:name, :description, :price, :brandId,
                           NOW(), 0, :available)
                """;

        jdbi.useHandle(h -> h.createUpdate(sql)
                .bindBean(product)
                .execute());
    }

    public void update(Product product) {
        String sql = """
                    UPDATE product
                    SET name = :name,
                        description = :description,
                        price = :price,
                        brand_id = :brandId,
                        is_available = :available
                    WHERE id = :id
                """;

        jdbi.useHandle(h -> h.createUpdate(sql)
                .bindBean(product)
                .execute());
    }

    public void delete(int id) {
        String sql = "UPDATE product SET is_discontinue = 1 WHERE id = :id";
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public List<Product> findByBrandLimit(int brandId, int limit) {
        String sql = """
                            SELECT p.* FROM product p
                            JOIN brand b ON p.brand_id = b.id
                            WHERE (:brandId IS NULL OR p.brand_id = :brandId)
                              AND b.is_active = 1
                              AND p.is_available = 1
                              AND p.is_discontinue = 0
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("brandId", brandId)
                .bind("limit", limit)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> findProductsInPromotion() {
        String sql = """
                    SELECT DISTINCT p.*
                    FROM product p
                    JOIN promotion_product pp ON p.id = pp.product_id
                    JOIN promotion pr ON pr.id = pp.promotion_id
                    WHERE p.is_available = 1
                      AND pr.is_active = 1
                      AND (pr.start_date IS NULL OR pr.start_date <= NOW())
                      AND (pr.end_date IS NULL OR pr.end_date >= NOW())
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Product> findNewestByBrandLimit(int brandId, int limit) {
        String sql = """
                    SELECT p.*
                    FROM product p
                    JOIN brand b ON p.brand_id = b.id
                    WHERE p.brand_id = :brandId
                      AND b.is_active = 1
                      AND p.is_available = 1
                      AND p.is_discontinue = 0
                      AND p.added_at IS NOT NULL
                    ORDER BY p.added_at DESC, p.id DESC
                    LIMIT :limit
                """;

        try {
            return jdbi.withHandle(handle -> handle.createQuery(sql)
                    .bind("brandId", brandId)
                    .bind("limit", limit)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public boolean isNew(int id) {
        String sql = """
                    SELECT COUNT(*)
                    FROM product
                    WHERE id = :id
                      AND is_available = 1
                      AND added_at >= NOW() - INTERVAL 7 DAY
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("id", id)
                    .mapTo(int.class)
                    .findOne()
                    .orElse(0) > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getDes(int productId) {
        String sql = """
                    SELECT description
                    FROM product
                    WHERE id = :productId
                      AND is_available = 1
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("productId", productId)
                    .mapTo(String.class)
                    .findOne()
                    .orElse(""));
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public List<Product> getRelatedProduct(int productId, int brandId, BigDecimal price, int limit) {
        String sql = """
                    SELECT *
                    FROM product
                    WHERE id != :productId
                      AND is_available = 1
                      AND brand_id = :brandId
                      AND price BETWEEN :minPrice AND :maxPrice
                    ORDER BY
                        ABS(price - :price) ASC
                    LIMIT :limit
                """;

        BigDecimal minPrice = price.multiply(new BigDecimal("0.8")); // -20%
        BigDecimal maxPrice = price.multiply(new BigDecimal("1.2")); // +20%

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("productId", productId)
                    .bind("brandId", brandId)
                    .bind("price", price)
                    .bind("minPrice", minPrice)
                    .bind("maxPrice", maxPrice)
                    .bind("limit", limit)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Product> findActivePage(int limit, int offset) {
        return JDBIConnector.getJdbi().withHandle(h -> h.createQuery("""
                    SELECT *
                    FROM product
                    WHERE is_available = 1
                      AND is_discontinue = 0
                    ORDER BY added_at DESC
                    LIMIT :limit OFFSET :offset
                """)
                .bind("limit", limit)
                .bind("offset", offset)
                .mapToBean(Product.class)
                .list());
    }

    public int countActive() {
        return JDBIConnector.getJdbi().withHandle(h -> h.createQuery("""
                    SELECT COUNT(*)
                    FROM product
                    WHERE is_available = 1
                      AND is_discontinue = 0
                """)
                .mapTo(int.class)
                .one());
    }

    public List<Product> searchByName(String keyword, int limit, int offset) {
        String sql = """
                    SELECT * FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                      AND name LIKE :keyword
                    ORDER BY added_at DESC
                    LIMIT :limit OFFSET :offset
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("keyword", "%" + keyword + "%")
                .bind("limit", limit)
                .bind("offset", offset)
                .mapToBean(Product.class)
                .list());
    }

    // Đếm kết quả tìm kiếm
    public int countSearchResults(String keyword) {
        String sql = """
                    SELECT COUNT(*) FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                      AND name LIKE :keyword
                """;
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("keyword", "%" + keyword + "%")
                .mapTo(int.class)
                .one());
    }

    // Lọc sản phẩm theo nhiều tiêu chí
    public List<Product> filterProducts(String keyword, List<Integer> brandIds,
            List<Integer> sizeIds, List<Integer> colorIds,
            BigDecimal minPrice, BigDecimal maxPrice,
            String sortBy, int limit, int offset) {
        StringBuilder sql = new StringBuilder("""
                    SELECT DISTINCT p.*, COALESCE(ep.effective_price, p.price) AS effective_price
                    FROM product p
                    LEFT JOIN product_variant pv ON p.id = pv.product_id
                    LEFT JOIN (
                        SELECT pp.product_id,
                               MIN(
                                   CASE
                                       WHEN pr.discount_type = 'PERCENT'
                                           THEN GREATEST(0, p2.price - (p2.price * pr.discount_value / 100))
                                       WHEN pr.discount_type = 'FIXED'
                                           THEN GREATEST(0, p2.price - pr.discount_value)
                                       ELSE p2.price
                                   END
                               ) AS effective_price
                        FROM promotion_product pp
                        JOIN promotion pr ON pr.id = pp.promotion_id
                        JOIN product p2 ON p2.id = pp.product_id
                        WHERE pr.is_active = 1
                          AND (pr.start_date IS NULL OR pr.start_date <= NOW())
                          AND (pr.end_date IS NULL OR pr.end_date >= NOW())
                        GROUP BY pp.product_id
                    ) ep ON ep.product_id = p.id
                    WHERE p.is_available = 1 AND p.is_discontinue = 0
                """);

        // Keyword filter
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE :keyword ");
        }

        // Brand filter
        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND p.brand_id IN (<brandIds>) ");
        }

        // Size filter
        if (sizeIds != null && !sizeIds.isEmpty()) {
            sql.append(" AND pv.size_id IN (<sizeIds>) ");
        }

        // Color filter
        if (colorIds != null && !colorIds.isEmpty()) {
            sql.append(" AND pv.color_id IN (<colorIds>) ");
        }

        // Price filter
        if (minPrice != null) {
            sql.append(" AND COALESCE(ep.effective_price, p.price) >= :minPrice ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(ep.effective_price, p.price) <= :maxPrice ");
        }

        // Sort
        String orderBy = switch (sortBy != null ? sortBy : "default") {
            case "newest" -> " ORDER BY p.added_at DESC ";
            case "price-asc" -> " ORDER BY COALESCE(ep.effective_price, p.price) ASC, p.id DESC ";
            case "price-desc" -> " ORDER BY COALESCE(ep.effective_price, p.price) DESC, p.id DESC ";
            default -> " ORDER BY p.added_at DESC ";
        };
        sql.append(orderBy);
        sql.append(" LIMIT :limit OFFSET :offset ");

        String finalSql = sql.toString();

        return jdbi.withHandle(h -> {
            var query = h.createQuery(finalSql);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword + "%");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                query.bindList("brandIds", brandIds);
            }
            if (sizeIds != null && !sizeIds.isEmpty()) {
                query.bindList("sizeIds", sizeIds);
            }
            if (colorIds != null && !colorIds.isEmpty()) {
                query.bindList("colorIds", colorIds);
            }
            if (minPrice != null) {
                query.bind("minPrice", minPrice);
            }
            if (maxPrice != null) {
                query.bind("maxPrice", maxPrice);
            }
            query.bind("limit", limit);
            query.bind("offset", offset);

            return query.mapToBean(Product.class).list();
        });
    }

    // Đếm số sản phẩm sau khi lọc
    public int countFilteredProducts(String keyword, List<Integer> brandIds,
            List<Integer> sizeIds, List<Integer> colorIds,
            BigDecimal minPrice, BigDecimal maxPrice) {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(DISTINCT p.id) FROM product p
                    LEFT JOIN product_variant pv ON p.id = pv.product_id
                    LEFT JOIN (
                        SELECT pp.product_id,
                               MIN(
                                   CASE
                                       WHEN pr.discount_type = 'PERCENT'
                                           THEN GREATEST(0, p2.price - (p2.price * pr.discount_value / 100))
                                       WHEN pr.discount_type = 'FIXED'
                                           THEN GREATEST(0, p2.price - pr.discount_value)
                                       ELSE p2.price
                                   END
                               ) AS effective_price
                        FROM promotion_product pp
                        JOIN promotion pr ON pr.id = pp.promotion_id
                        JOIN product p2 ON p2.id = pp.product_id
                        WHERE pr.is_active = 1
                          AND (pr.start_date IS NULL OR pr.start_date <= NOW())
                          AND (pr.end_date IS NULL OR pr.end_date >= NOW())
                        GROUP BY pp.product_id
                    ) ep ON ep.product_id = p.id
                    WHERE p.is_available = 1 AND p.is_discontinue = 0
                """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE :keyword ");
        }
        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND p.brand_id IN (<brandIds>) ");
        }
        if (sizeIds != null && !sizeIds.isEmpty()) {
            sql.append(" AND pv.size_id IN (<sizeIds>) ");
        }
        if (colorIds != null && !colorIds.isEmpty()) {
            sql.append(" AND pv.color_id IN (<colorIds>) ");
        }
        if (minPrice != null) {
            sql.append(" AND COALESCE(ep.effective_price, p.price) >= :minPrice ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(ep.effective_price, p.price) <= :maxPrice ");
        }

        String finalSql = sql.toString();

        return jdbi.withHandle(h -> {
            var query = h.createQuery(finalSql);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword + "%");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                query.bindList("brandIds", brandIds);
            }
            if (sizeIds != null && !sizeIds.isEmpty()) {
                query.bindList("sizeIds", sizeIds);
            }
            if (colorIds != null && !colorIds.isEmpty()) {
                query.bindList("colorIds", colorIds);
            }
            if (minPrice != null) {
                query.bind("minPrice", minPrice);
            }
            if (maxPrice != null) {
                query.bind("maxPrice", maxPrice);
            }

            return query.mapTo(int.class).one();
        });
    }

    public List<Product> getNewestProducts(int limit) {
        String sql = """
                    SELECT *
                    FROM product
                    ORDER BY added_at DESC
                    LIMIT :limit
                """;

        return JDBIConnector.getJdbi().withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> findAll() {
        String sql = """
                SELECT *
                FROM product
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> findWithFilter(Integer id, String nameParam, Integer brandId) {
        StringBuilder sql = new StringBuilder("""
                        SELECT *
                    FROM product
                    WHERE 1=1
                """);

        if (id != null) {
            sql.append(" AND id = :id");
        }

        if (nameParam != null && !nameParam.isBlank()) {
            sql.append(" AND name LIKE :name");
        }

        if (brandId != null) {
            sql.append(" AND brand_id = :brandId");
        }

        sql.append(" ORDER BY added_at DESC");

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (id != null) {
                query.bind("id", id);
            }

            if (nameParam != null && !nameParam.isBlank()) {
                query.bind("name", "%" + nameParam + "%");
            }

            if (brandId != null) {
                query.bind("brandId", brandId);
            }

            return query
                    .mapToBean(Product.class)
                    .list();
        });
    }
}
