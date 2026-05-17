package dao.cart;
import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;

public class CartDao {
    private final Jdbi jdbi = JDBIConnector.getJdbi();

    public int getOrCreateCartId(int userId) {
        Integer cartId = jdbi.withHandle(h -> h.createQuery(
                "SELECT id FROM carts WHERE user_id = :userId"
        ).bind("userId", userId).mapTo(Integer.class).findOne().orElse(null));

        if (cartId != null) return cartId;

        return jdbi.withHandle(h -> h.createUpdate(
                        "INSERT INTO carts(user_id) VALUES(:userId)"
                ).bind("userId", userId)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public List<CartItemRow> findItemsByUserId(int userId) {
        String sql = """
        SELECT 
            ci.id AS id,
            ci.cart_id AS cartId,
            ci.product_id AS productId,
            ci.color_id AS colorId,
            ci.size_id AS sizeId,
            ci.quantity AS quantity,
            ci.unit_price AS unitPrice
        FROM cart_items ci
        JOIN carts c ON c.id = ci.cart_id
        WHERE c.user_id = :userId
        ORDER BY ci.updated_at DESC
    """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("userId", userId)
                .mapToBean(CartItemRow.class)
                .list());
    }

    public void upsertItem(int userId, int productId, int colorId, int sizeId, int quantity, BigDecimal unitPrice) {
        int cartId = getOrCreateCartId(userId);

        String sql = """
            INSERT INTO cart_items(cart_id, product_id, color_id, size_id, quantity, unit_price)
            VALUES(:cartId, :productId, :colorId, :sizeId, :quantity, :unitPrice)
            ON DUPLICATE KEY UPDATE
                quantity = quantity + VALUES(quantity),
                unit_price = VALUES(unit_price)
        """;

        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("cartId", cartId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .bind("quantity", quantity)
                .bind("unitPrice", unitPrice)
                .execute());
    }

    public void updateQuantity(int userId, int productId, int colorId, int sizeId, int quantity) {
        String sql = """
            UPDATE cart_items ci
            JOIN carts c ON c.id = ci.cart_id
            SET ci.quantity = :quantity
            WHERE c.user_id = :userId
              AND ci.product_id = :productId
              AND ci.color_id = :colorId
              AND ci.size_id = :sizeId
        """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("quantity", quantity)
                .bind("userId", userId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .execute());
    }

    public void removeItem(int userId, int productId, int colorId, int sizeId) {
        String sql = """
            DELETE ci FROM cart_items ci
            JOIN carts c ON c.id = ci.cart_id
            WHERE c.user_id = :userId
              AND ci.product_id = :productId
              AND ci.color_id = :colorId
              AND ci.size_id = :sizeId
        """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .execute());
    }

    public void clearCart(int userId) {
        String sql = """
            DELETE ci FROM cart_items ci
            JOIN carts c ON c.id = ci.cart_id
            WHERE c.user_id = :userId
        """;
        jdbi.useHandle(h -> h.createUpdate(sql)
                .bind("userId", userId)
                .execute());
    }}
