
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
            String phoneNumber, String orderNote,
            String recipientName, String recipientPhone,
            String province, String district, String ward, String street) {
        return handle.createUpdate("""
                    INSERT INTO orders
                    (user_id, sub_total, shipping_fee, grand_total,
                     order_status, payment_method, payment_status,
                     shipping_address, phone_number, order_note,
                     recipient_name, recipient_phone,
                     province, district, ward, street)
                    VALUES
                    (:user_id, :sub_total, :shipping_fee, :grand_total,
                     :order_status, :payment_method, :payment_status,
                     :shipping_address, :phone_number, :order_note,
                     :recipient_name, :recipient_phone,
                     :province, :district, :ward, :street)
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
                .bind("recipient_name", recipientName)
                .bind("recipient_phone", recipientPhone)
                .bind("province", province)
                .bind("district", district)
                .bind("ward", ward)
                .bind("street", street)
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
                    o.phone_number,
                    o.payment_method,
                    o.cancel_reason,
                    o.recipient_name,
                    o.recipient_phone,
                    o.province,
                    o.district,
                    o.ward,
                    o.street
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

    public int countByUserId(int userId) {
        String sql = """
                SELECT COUNT(*)
                FROM orders o
                WHERE o.user_id = :userId
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one());
    }

    public List<Order> findByUserIdWithPagination(int userId, int limit, int offset) {
        String sql = """
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
                    o.phone_number,
                    o.payment_method,
                    o.cancel_reason,
                    o.recipient_name,
                    o.recipient_phone,
                    o.province,
                    o.district,
                    o.ward,
                    o.street
                FROM orders o
                WHERE o.user_id = :userId
                ORDER BY o.created_at DESC
                LIMIT :limit OFFSET :offset
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("limit", limit)
                .bind("offset", offset)
                .mapToBean(Order.class)
                .list());
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
                WHERE payment_status = 'PAID'
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
                    WHERE payment_status = 'PAID'
                      AND DATE(created_at) = CURRENT_DATE
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(BigDecimal.class)
                .one());
    }

    public void cancelOrder(Handle handle, int orderId, String cancelReason) {
        handle.createUpdate("""
                    UPDATE orders
                    SET order_status = :order_status,
                        cancel_reason = :cancel_reason
                    WHERE id = :order_id
                """)
                .bind("order_status", OrderStatus.CANCELLED.name())
                .bind("cancel_reason", cancelReason)
                .bind("order_id", orderId)
                .execute();
    }

    public String getOrderStatusById(int orderId) {
        String sql = """
                SELECT order_status
                FROM orders
                WHERE id = :order_id
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("order_id", orderId)
                .mapTo(String.class)
                .findOne()
                .orElse(null));
    }

    public String getShippingStatusById(int orderId) {
        String sql = """
                SELECT shipping_status
                FROM orders
                WHERE id = :order_id
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("order_id", orderId)
                .mapTo(String.class)
                .findOne()
                .orElse(null));
    }

    public Order findById(int orderId) {
        String sql = """
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
                    o.phone_number,
                    o.payment_method,
                    o.cancel_reason,
                    o.recipient_name,
                    o.recipient_phone,
                    o.province,
                    o.district,
                    o.ward,
                    o.street
                FROM orders o
                WHERE o.id = :order_id
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("order_id", orderId)
                .mapToBean(Order.class)
                .findOne()
                .orElse(null));
    }

    public int countAll(String search, String status, String paymentStatus) {
        StringBuilder sql = new StringBuilder("""
                SELECT COUNT(*)
                FROM orders o
                WHERE 1 = 1
                """);

        if (search != null && !search.isBlank()) {
            sql.append(" AND (o.id LIKE :search OR o.phone_number LIKE :search2 OR o.recipient_phone LIKE :search3)");
        }
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND o.order_status = :status");
        }
        if (paymentStatus != null && !paymentStatus.isEmpty() && !"all".equals(paymentStatus)) {
            sql.append(" AND o.payment_status = :paymentStatus");
        }

        final String queryStr = sql.toString();
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(queryStr);
            if (search != null && !search.isBlank()) {
                String searchPattern = "%" + search.trim() + "%";
                query.bind("search", searchPattern);
                query.bind("search2", searchPattern);
                query.bind("search3", searchPattern);
            }
            if (status != null && !status.isEmpty() && !"all".equals(status)) {
                query.bind("status", status.toUpperCase());
            }
            if (paymentStatus != null && !paymentStatus.isEmpty() && !"all".equals(paymentStatus)) {
                query.bind("paymentStatus", paymentStatus.toUpperCase());
            }
            return query.mapTo(Integer.class).one();
        });
    }

    public List<Order> findAllWithPaginationAndFilters(int page, int pageSize, String search, String status, String paymentStatus) {
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
                    o.phone_number,
                    o.payment_method,
                    o.cancel_reason,
                    o.recipient_name,
                    o.recipient_phone,
                    o.province,
                    o.district,
                    o.ward,
                    o.street
                FROM orders o
                WHERE 1 = 1
                """);

        if (search != null && !search.isBlank()) {
            sql.append(" AND (o.id LIKE :search OR o.phone_number LIKE :search2 OR o.recipient_phone LIKE :search3)");
        }
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND o.order_status = :status");
        }
        if (paymentStatus != null && !paymentStatus.isEmpty() && !"all".equals(paymentStatus)) {
            sql.append(" AND o.payment_status = :paymentStatus");
        }

        sql.append(" ORDER BY o.created_at DESC");
        sql.append(" LIMIT :limit OFFSET :offset");

        int offset = (page - 1) * pageSize;
        final String queryStr = sql.toString();
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(queryStr);
            if (search != null && !search.isBlank()) {
                String searchPattern = "%" + search.trim() + "%";
                query.bind("search", searchPattern);
                query.bind("search2", searchPattern);
                query.bind("search3", searchPattern);
            }
            if (status != null && !status.isEmpty() && !"all".equals(status)) {
                query.bind("status", status.toUpperCase());
            }
            if (paymentStatus != null && !paymentStatus.isEmpty() && !"all".equals(paymentStatus)) {
                query.bind("paymentStatus", paymentStatus.toUpperCase());
            }
            query.bind("limit", pageSize);
            query.bind("offset", offset);
            return query.mapToBean(Order.class).list();
        });
    }

    public void updateOrderStatus(int orderId, String newStatus) {
        String sql = """
                UPDATE orders
                SET order_status = :order_status
                WHERE id = :order_id
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("order_status", newStatus.toUpperCase())
                .bind("order_id", orderId)
                .execute());
    }

    public void updatePaymentStatus(int orderId, String newPaymentStatus) {
        String sql = """
                UPDATE orders
                SET payment_status = :payment_status
                WHERE id = :order_id
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("payment_status", newPaymentStatus.toUpperCase())
                .bind("order_id", orderId)
                .execute());
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
