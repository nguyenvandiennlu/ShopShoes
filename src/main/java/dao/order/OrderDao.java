
package dao.order;

import java.math.BigDecimal;
import java.util.List;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.Order.Order;

public class OrderDao {

    private final Jdbi jdbi;

    public OrderDao() {
        jdbi = JDBIConnector.getJdbi();
    }

    public int insertOrder(Handle handle, int userId, BigDecimal subTotal, BigDecimal shippingFee,
            BigDecimal grandTotal) {
        return handle.createUpdate("""
                    INSERT INTO orders
                    (user_id, sub_total, shipping_fee, grand_total,
                     order_status, payment_status)
                    VALUES
                    (:user_id, :sub_total, :shipping_fee, :grand_total,
                     'NEW', 'UNPAID')
                """)
                .bind("user_id", userId)
                .bind("sub_total", subTotal)
                .bind("shipping_fee", shippingFee)
                .bind("grand_total", grandTotal)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();
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
                    o.created_at
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
                WHERE order_status = 'COMPLETED'
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
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

    public BigDecimal todayRevenue() {
        String sql = """
                    SELECT COALESCE(SUM(grand_total), 0)
                    FROM orders
                    WHERE order_status = 'COMPLETED'
                      AND DATE(created_at) = CURRENT_DATE
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(BigDecimal.class)
                .one());
    }
}