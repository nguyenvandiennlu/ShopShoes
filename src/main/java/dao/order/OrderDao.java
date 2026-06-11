
package dao.order;

import java.math.BigDecimal;
import java.util.List;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.Order.Order;
import enums.OrderStatus;
import enums.PaymentMethod;
import enums.PaymentStatus;

public class OrderDao {

    private final Jdbi jdbi;

    public OrderDao() {
        jdbi = JDBIConnector.getJdbi();
    }

    public int insertOrder(Handle handle, int userId, BigDecimal subTotal, BigDecimal shippingFee,
            BigDecimal grandTotal, PaymentMethod paymentMethod, String shippingAddress,
            String phoneNumber, String orderNote) {
        return handle.createUpdate("""
                    INSERT INTO orders
                    (user_id, sub_total, shipping_fee, grand_total,
                     order_status, payment_method, payment_status, shipping_address, phone_number, order_note)
                    VALUES
                    (:user_id, :sub_total, :shipping_fee, :grand_total,
                     :order_status, :payment_method, :payment_status, :shipping_address, :phone_number, :order_note)
                """)
                .bind("user_id", userId)
                .bind("sub_total", subTotal)
                .bind("shipping_fee", shippingFee)
                .bind("grand_total", grandTotal)
                .bind("order_status", OrderStatus.NEW.name())
                .bind("payment_method", paymentMethod.name())
                .bind("payment_status", PaymentStatus.UNPAID.name())
                .bind("shipping_address", shippingAddress)
                .bind("phone_number", phoneNumber)
                .bind("order_note", orderNote)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();
    }

    public void updatePaymentStatus(Handle handle, int orderId, PaymentStatus paymentStatus) {
        handle.createUpdate("""
                    UPDATE orders
                    SET payment_status = :payment_status
                    WHERE id = :order_id
                """)
                .bind("payment_status", paymentStatus.name())
                .bind("order_id", orderId)
                .execute();
    }

    public PaymentStatus getPaymentStatusByOrderId(int orderId) {
        String sql = """
                SELECT payment_status
                FROM orders
                WHERE id = :order_id
                """;

        String status = jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("order_id", orderId)
                .mapTo(String.class)
                .findOne()
                .orElse(null));

        if (status == null || status.isBlank()) {
            return null;
        }
        return PaymentStatus.valueOf(status);
    }

    public List<Order> findWithFilter(Integer orderId, Integer userId, String status) {
        StringBuilder sql = new StringBuilder("""
                SELECT
                    o.id,
                    o.user_id,
                    o.sub_total,
                    o.shipping_fee,
                    o.grand_total,
                    o.order_status,
                    o.payment_status,
                    o.shipping_status,
                    o.orders_id,
                    o.created_at,
                    o.shipping_address,
                    o.phone_number
                FROM orders o
                WHERE 1 = 1
                """);

        if (orderId != null) {
            sql.append(" AND o.id = :orderId");
        }

        if (userId != null) {
            sql.append(" AND o.user_id = :userId");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.order_status = :status");
        }

        sql.append(" ORDER BY o.created_at DESC");

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (orderId != null) {
                query.bind("orderId", orderId);
            }

            if (userId != null) {
                query.bind("userId", userId);
            }

            if (status != null && !status.isEmpty()) {
                query.bind("status", status.toUpperCase());
            }

            return query
                    .mapToBean(Order.class)
                    .list();
        });
    }

    public List<Order> findAll() {
        String sql = """
                SELECT *
                FROM orders
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Order.class)
                .list());
    }

    public BigDecimal totalRevenue() {
        String sql = """
                SELECT COALESCE(SUM(grand_total), 0)
                FROM orders
                WHERE order_status = :status
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("status", enums.OrderStatus.COMPLETED.name())
                .mapTo(BigDecimal.class)
                .one());
    }

    public int todayOrders() {
        String sql = """
                SELECT COUNT(*)
                FROM orders
                WHERE created_at >= CURRENT_DATE
                  AND created_at < CURRENT_DATE + INTERVAL 1 DAY
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public Integer findUserIdByOrderId(Handle handle, int orderId) {
        return handle.createQuery("""
                    SELECT user_id
                    FROM orders
                    WHERE id = :orderId
                """)
                .bind("orderId", orderId)
                .mapTo(Integer.class)
                .findOne()
                .orElse(null);
    }

    public Integer findUserIdByOrderId(int orderId) {
        return jdbi.withHandle(handle -> findUserIdByOrderId(handle, orderId));
    }

    public BigDecimal todayRevenue() {
        String sql = """
                    SELECT COALESCE(SUM(grand_total), 0)
                    FROM orders
                    WHERE order_status = :status
                      AND DATE(created_at) = CURRENT_DATE
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("status", enums.OrderStatus.COMPLETED.name())
                .mapTo(BigDecimal.class)
                .one());
    }

    public boolean checkUserPurchasedProduct(int userId, int productId) {
        String sql = """
                SELECT COUNT(*)
                FROM orders o
                JOIN order_detail od ON o.id = od.order_id
                WHERE o.user_id = :userId
                  AND od.product_id = :productId
                  AND o.order_status IN ('DELIVERED', 'COMPLETED')
                """;

        int count = jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .one());

        return count > 0;
    }
}
