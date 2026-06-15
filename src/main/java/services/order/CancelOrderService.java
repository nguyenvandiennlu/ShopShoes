package services.order;

import dao.JDBIConnector;
import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import dao.product.ProductVariantDao;
import enums.PaymentMethod;
import enums.PaymentStatus;
import model.Order.Order;
import model.Order.OrderDetail;
import enums.OrderStatus;
import org.jdbi.v3.core.Jdbi;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class CancelOrderService {

    private final OrderDao orderDao;
    private final OrderDetailDao orderDetailDao;
    private final ProductVariantDao variantDao;
    private final Jdbi jdbi;

    public CancelOrderService() {
        this.orderDao = new OrderDao();
        this.orderDetailDao = new OrderDetailDao();
        this.variantDao = new ProductVariantDao();
        this.jdbi = JDBIConnector.getJdbi();
    }

    /**
     * Validates if an order can be cancelled.
     *
     * @param orderId The order ID
     * @param userId  The user ID requesting cancellation
     * @return Error message if cannot cancel, null if OK
     */
    public String validateCancelOrder(int orderId, int userId) {
        Order order = orderDao.findById(orderId);

        if (order == null) {
            return "Đơn hàng không tồn tại.";
        }

        if (order.getUserId() != userId) {
            return "Bạn không có quyền hủy đơn hàng này.";
        }

        // Check if order is already cancelled
        if (order.getOrderStatus() == OrderStatus.CANCELLED) {
            return "Đơn hàng này đã được hủy trước đó.";
        }

        // Check if order is in a state that can be cancelled (NEW or PROCESSING only)
        String status = order.getOrderStatus().name();
        if (!"NEW".equals(status) && !"PROCESSING".equals(status)) {
            return "Đơn hàng không thể hủy vì đã được đóng gói hoặc đang được vận chuyển.";
        }

        // Check 24-hour window
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime createdAt = order.getCreatedAt();
        if (createdAt != null) {
            long hoursSinceOrder = ChronoUnit.HOURS.between(createdAt, now);
            if (hoursSinceOrder > 24) {
                return "Đã quá 24 giờ kể từ khi đặt hàng, bạn không thể hủy đơn hàng này.";
            }
        }

        // Check shipping status - must not be shipped or delivered
        String shippingStatus = orderDao.getShippingStatusById(orderId);
        if (shippingStatus != null && !shippingStatus.isBlank()) {
            String ss = shippingStatus.toUpperCase();
            if ("SHIPPING".equals(ss) || "DELIVERED".equals(ss)) {
                return "Đơn hàng đang được vận chuyển hoặc đã giao, không thể hủy.";
            }
        }

        return null; // OK to cancel
    }

    /**
     * Executes the cancellation logic in a transaction.
     *
     * @param orderId      The order ID to cancel
     * @param cancelReason The reason for cancellation
     * @return Error message if something fails, null if success
     */
    public String cancelOrder(int orderId, String cancelReason) {
        try {
            jdbi.useTransaction(handle -> {
                // 1. Get order details (items) to restore stock
                List<OrderDetail> details = orderDetailDao.findDetailByOrderId(orderId);

                // 2. Restore stock for each item
                for (OrderDetail detail : details) {
                    variantDao.restoreStock(
                            handle,
                            detail.getProductId(),
                            detail.getColorId(),
                            detail.getSizeId(),
                            detail.getQuantity()
                    );
                }

                // 3. Update order status to CANCELLED and set cancel reason
                orderDao.cancelOrder(handle, orderId, cancelReason);
            });

            return null; // Success
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi hệ thống khi hủy đơn hàng: " + e.getMessage();
        }
    }

    /**
     * Checks if the order was paid with Momo and returns a refund notification message.
     *
     * @param orderId The order ID
     * @return Notification message about refund, or null if COD
     */
    public String getRefundNotification(int orderId) {
        Order order = orderDao.findById(orderId);
        if (order == null) {
            return null;
        }

        if (order.getPaymentMethod() == PaymentMethod.MOMO
                && order.getPaymentStatus() == PaymentStatus.PAID) {
            return "Đơn hàng của bạn đã thanh toán qua Momo. Chúng tôi sẽ hoàn tiền vào tài khoản Momo của bạn trong thời gian sớm nhất (1-3 ngày làm việc).";
        }

        return null;
    }
}