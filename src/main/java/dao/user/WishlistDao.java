package dao.user;

import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.user.WishList;

public class WishlistDao {
    private final Jdbi jdbi;

    public WishlistDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }


    public boolean add(int userId, int productId) {
        try {
            if (exists(userId, productId)) {
                return false;
            }

            String sql = """
                INSERT INTO wishlist (user_id, product_id, added_at)
                VALUES (:userId, :productId, NOW())
            """;
            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .execute()
            );
            return true;

        } catch (Exception e) {
            e.printStackTrace(); // log
            return false;
        }
    }

    public boolean exists(int userId, int productId) {
        try {
            String sql = """
                SELECT COUNT(*) 
                FROM wishlist 
                WHERE user_id = :userId 
                  AND product_id = :productId
            """;

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .mapTo(Integer.class)
                            .one()
            ) > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean remove(int userId, int productId) {
        try {
            String sql = """
                DELETE FROM wishlist
                WHERE user_id = :userId
                  AND product_id = :productId
            """;

            int affected = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .execute()
            );

            return affected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countByUser(int userId) {
        try {
            String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = :userId";
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<WishList> findByUser(int userId) {
        try {
            String sql = """
                SELECT id,
                       product_id,
                       user_id,
                       added_at 
                FROM wishlist
                WHERE user_id = :userId
                ORDER BY added_at DESC
            """;

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .mapToBean(WishList.class)
                            .list()
            );

        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public List<WishList> findAll()
    {
        String sql = """
        SELECT id,
               product_id,
               user_id,
               added_at
        FROM wishlist
        ORDER BY added_at DESC
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(WishList.class)
                        .list()
        );
    }

}
