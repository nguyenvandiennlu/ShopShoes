package dao.product;

import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Brand;

public class BrandDao {

    private final Jdbi jdbi;

    public BrandDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public List<Brand> findAllActive() {
        String sql = "SELECT * FROM brand WHERE is_active = 1";

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .mapToBean(Brand.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public Brand findBrandOfProduct(int productId) {

        String sql = """
        SELECT b.*
        FROM product p
        JOIN brand b ON p.brand_id = b.id
        WHERE p.id = :productId
          AND p.is_available = 1
          AND b.is_active = 1
    """;

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(Brand.class)
                            .findOne()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Brand> findAll()
    {
        String sql = "SELECT * FROM brand";

        try {
            return jdbi.withHandle(h ->
                    h.createQuery(sql)
                            .mapToBean(Brand.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
