package dao.order;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.jdbi.v3.core.Handle;

import dao.JDBIConnector;
import model.Order.OrderDetailDTO;
import model.cart.CartItem;

public class OrderDetailDao {

    public void insertOrderDetails(
            Handle handle,
            int orderId,
            Map<String, CartItem> cart,
            Map<String, BigDecimal> unitPrices) {
        for (CartItem item : cart.values()) {

            BigDecimal unitPrice = unitPrices.get(item.getKey());
            BigDecimal subtotal = unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()));

            handle.createUpdate("""
                        INSERT INTO order_detail
                        (order_id, product_id, color_id, size_id,
                         quantity, unit_price, subtotal)
                        VALUES
                        (:order_id, :product_id, :color_id, :size_id,
                         :quantity, :unit_price, :subtotal)
                    """)
                    .bind("order_id", orderId)
                    .bind("product_id", item.getProductId())
                    .bind("color_id", item.getColorId())
                    .bind("size_id", item.getSizeId())
                    .bind("quantity", item.getQuantity())
                    .bind("unit_price", unitPrice)
                    .bind("subtotal", subtotal)
                    .execute();
        }
    }

    public List<OrderDetailDTO> findByOrderId(int orderId) {
        String sql = """
                    SELECT
                        od.product_id,
                        p.name as productName,
                        c.name as colorName,
                        s.name as sizeName,
                        od.quantity,
                        od.unit_price as unitPrice,
                        (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as imageUrl
                    FROM order_detail od
                    JOIN product p ON od.product_id = p.id
                    LEFT JOIN color c ON od.color_id = c.id
                    LEFT JOIN size s ON od.size_id = s.id
                    WHERE od.order_id = :orderId
                """;

        return JDBIConnector.getJdbi().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapToBean(OrderDetailDTO.class)
                .list());
    }

    public List<model.Order.OrderDetail> findDetailByOrderId(int orderId) {
        String sql = """
                    SELECT
                        od.id,
                        od.order_id,
                        od.product_id,
                        od.color_id,
                        od.size_id,
                        od.quantity,
                        od.unit_price,
                        od.subtotal
                    FROM order_detail od
                    WHERE od.order_id = :orderId
                """;

        return JDBIConnector.getJdbi().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapToBean(model.Order.OrderDetail.class)
                .list());
    }
}
