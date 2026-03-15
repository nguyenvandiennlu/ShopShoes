package dao.product;

import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Color;
import model.product.ProductVariant;
import model.product.Size;

public class ProductVariantDao {

    private final Jdbi jdbi = JDBIConnector.getJdbi();

    public List<Color> findColorsByProduct(int productId) {
        String sql = """
            SELECT DISTINCT c.*
            FROM product_variant v
            JOIN color c ON v.color_id = c.id
            JOIN product p ON v.product_id = p.id
            WHERE v.product_id = :productId
              AND p.is_available = 1
              AND v.is_discontinue_variant = 0
            ORDER BY c.id
        """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(Color.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Size> findSizesByProductAndColor(int productId, int colorId) {

        String sql = """
            SELECT DISTINCT s.*
            FROM product_variant v
            JOIN size s ON v.size_id = s.id
            WHERE v.product_id = :productId
              AND v.color_id = :colorId
              AND v.is_discontinue_variant = 0
            ORDER BY s.id
        """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapToBean(Size.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public int getStock(int productId, int colorId, int sizeId) {

        String sql = """
            SELECT stock
            FROM product_variant
            WHERE product_id = :productId
              AND color_id = :colorId
              AND size_id = :sizeId
              AND is_discontinue_variant = 0
        """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .bind("sizeId", sizeId)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getTotalStockByColor(int productId, int colorId) {
        String sql = """
        SELECT COALESCE(SUM(stock), 0)
        FROM product_variant
        WHERE product_id = :productId
          AND color_id = :colorId
          AND is_discontinue_variant = 0
    """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Integer findDefaultColorId(int productId) {

        String sql = """
        SELECT v.color_id
        FROM product_variant v
        WHERE v.product_id = :productId
          AND v.is_discontinue_variant = 0
        GROUP BY v.color_id
        HAVING SUM(v.stock) > 0
        ORDER BY MIN(v.id) ASC
        LIMIT 1
    """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean existsProductVariant(int productId, Integer colorId, Integer sizeId) {
        if (colorId == null || sizeId == null) {
            return false;
        }
        String sql = """
        SELECT COUNT(*)
        FROM product_variant v
        WHERE v.product_id = :productId
          AND v.color_id = :colorId
          AND v.size_id = :sizeId
          AND v.is_discontinue_variant = 0
    """;
        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .bind("sizeId", sizeId)
                            .mapTo(Integer.class)
                            .one() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getColorName(int colorId) {

        String sql = """
        SELECT name
        FROM color
        WHERE id = :colorId
    """;
        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("colorId", colorId)
                            .mapTo(String.class)
                            .findOne()
                            .orElse("")
            );
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public String getSizeName(int sizeId) {

        String sql = """
        SELECT name
        FROM size
        WHERE id = :sizeId
    """;
        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("sizeId", sizeId)
                            .mapTo(String.class)
                            .findOne()
                            .orElse("")
            );
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }


    public void updateStock(Handle handle, int productId, int colorId, int sizeId, int quantity) {
        String sql = """
        UPDATE product_variant
        SET stock = stock - :quantity
        WHERE product_id = :productId
          AND color_id = :colorId
          AND size_id = :sizeId
          AND stock >= :quantity
    """;

        int affected = handle.createUpdate(sql)
                .bind("quantity", quantity)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .execute();

        if (affected == 0) {
            throw new RuntimeException("Không đủ tồn kho");
        }
    }


    // ===== ADMIN: FIND ALL ACTIVE VARIANTS =====
    public List<ProductVariant> findAllActive() {
        String sql = """
        SELECT
            id,
            product_id AS productId,
            size_id    AS sizeId,
            color_id   AS colorId,
            stock,
            is_discontinue_variant AS discontinueVariant
        FROM product_variant
        WHERE is_discontinue_variant = 0
        ORDER BY id ASC
    """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(ProductVariant.class)
                        .list()
        );
    }
    // ===== ADMIN: SEARCH / FILTER VARIANTS =====
    public List<ProductVariant> findWithFilter(
            Integer productId,
            Integer sizeId,
            Integer colorId
    ) {
        StringBuilder sql = new StringBuilder("""
        SELECT
            id,
            product_id AS productId,
            size_id    AS sizeId,
            color_id   AS colorId,
            stock,
            is_discontinue_variant AS discontinueVariant
        FROM product_variant
        WHERE is_discontinue_variant = 0
    """);

        if (productId != null) {
            sql.append(" AND product_id = :productId");
        }
        if (sizeId != null) {
            sql.append(" AND size_id = :sizeId");
        }
        if (colorId != null) {
            sql.append(" AND color_id = :colorId");
        }

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sql.toString());
            if (productId != null) query.bind("productId", productId);
            if (sizeId != null) query.bind("sizeId", sizeId);
            if (colorId != null) query.bind("colorId", colorId);

            return query.mapToBean(ProductVariant.class).list();
        });
    }

}