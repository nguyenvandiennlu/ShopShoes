package dao.collection;

import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Product;


public class CollectionProductDao {

    private final Jdbi jdbi;

    public CollectionProductDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public List<Product> getProductsInCollection(int collectionId) {
        String sql = """
                    SELECT p.*
                    FROM product p
                    JOIN collection_product cp ON p.id = cp.product_id
                    WHERE cp.collection_id = :collectionId
                      AND p.is_available = 1
                      AND p.is_discontinue = 0
                    ORDER BY cp.sort_order ASC
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("collectionId", collectionId)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Product> getProductsInCollectionPaged(int collectionId, int limit, int offset) {
        String sql = """
                    SELECT p.*
                    FROM product p
                    JOIN collection_product cp ON p.id = cp.product_id
                    WHERE cp.collection_id = :collectionId
                      AND p.is_available = 1
                      AND p.is_discontinue = 0
                    ORDER BY cp.sort_order ASC
                    LIMIT :limit OFFSET :offset
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("collectionId", collectionId)
                    .bind("limit", limit)
                    .bind("offset", offset)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }


    public int countProductsInCollection(int collectionId) {
        String sql = """
                    SELECT COUNT(*)
                    FROM collection_product cp
                    JOIN product p ON p.id = cp.product_id
                    WHERE cp.collection_id = :collectionId
                      AND p.is_available = 1
                      AND p.is_discontinue = 0
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("collectionId", collectionId)
                    .mapTo(int.class)
                    .one());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


    public boolean addProductToCollection(int collectionId, int productId) {
        String sql = """
                    INSERT INTO collection_product (collection_id, product_id, sort_order)
                    SELECT :collectionId, :productId, COALESCE(MAX(sort_order), 0) + 1
                    FROM collection_product
                    WHERE collection_id = :collectionId
                """;

        try {
            int inserted = jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", collectionId)
                    .bind("productId", productId)
                    .execute());
            return inserted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean removeProductFromCollection(int collectionId, int productId) {
        String sql = """
                    DELETE FROM collection_product
                    WHERE collection_id = :collectionId AND product_id = :productId
                """;

        try {
            int deleted = jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", collectionId)
                    .bind("productId", productId)
                    .execute());
            return deleted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateSortOrder(int collectionId, int productId, int newSortOrder) {
        String sql = """
                    UPDATE collection_product
                    SET sort_order = :sortOrder
                    WHERE collection_id = :collectionId AND product_id = :productId
                """;

        try {
            int updated = jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", collectionId)
                    .bind("productId", productId)
                    .bind("sortOrder", newSortOrder)
                    .execute());
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean isProductInCollection(int collectionId, int productId) {
        String sql = """
                    SELECT COUNT(*) FROM collection_product
                    WHERE collection_id = :collectionId AND product_id = :productId
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("collectionId", collectionId)
                    .bind("productId", productId)
                    .mapTo(int.class)
                    .one() > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean clearCollection(int collectionId) {
        String sql = "DELETE FROM collection_product WHERE collection_id = :collectionId";

        try {
            jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", collectionId)
                    .execute());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
