package services.checkout;

import dao.JDBIConnector;
import dao.cart.CartDao;
import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import dao.product.ProductVariantDao;
import dao.user.UserDao;
import enums.PaymentMethod;
import enums.PaymentStatus;
import model.cart.CartItem;
import model.user.User;
import org.jdbi.v3.core.Jdbi;
import services.common.EmailServices;
import services.product.PromotionService;
import utils.EmailTemplateBuilder;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CheckoutService {

    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final CartDao cartDao = new CartDao();
    private final OrderDao orderDao = new OrderDao();
    private final OrderDetailDao orderDetailDao = new OrderDetailDao();
    private final PromotionService promotionService = new PromotionService();

    private final Jdbi jdbi;

    public CheckoutService() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public int placeOrder(
            int userId,
            Map<String, CartItem> cart,
            BigDecimal shippingFee,
            PaymentMethod paymentMethod,
            String shippingAddress,
            String phoneNumber,
            String orderNote,
            String recipientName,
            String recipientPhone,
            String province,
            String district,
            String ward,
            String street
    ) {

        return jdbi.inTransaction(handle -> {

            BigDecimal subTotal = BigDecimal.ZERO;
            Map<String, BigDecimal> unitPrices = new HashMap<>();

            for (CartItem item : cart.values()) {
                if (item.getQuantity() <= 0) {
                    throw new RuntimeException("So luong san pham khong hop le");
                }

                BigDecimal unitPrice =
                        promotionService.parsePrice(item.getFinalPrice());

                unitPrices.put(item.getKey(), unitPrice);

                subTotal = subTotal.add(
                        unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()))
                );
            }
            BigDecimal grandTotal = subTotal.add(shippingFee);

            int orderId = orderDao.insertOrder(
                    handle,
                    userId,
                    subTotal,
                    shippingFee,
                    grandTotal,
                    paymentMethod,
                    shippingAddress,
                    phoneNumber,
                    orderNote,
                    recipientName,
                    recipientPhone,
                    province,
                    district,
                    ward,
                    street
            );

            if (paymentMethod == PaymentMethod.COD) {
                orderDetailDao.insertOrderDetails(
                        handle,
                        orderId,
                        cart,
                        unitPrices
                );

                for (CartItem item : cart.values()) {
                    variantDao.updateStock(
                            handle,
                            item.getProductId(),
                            item.getColorId(),
                            item.getSizeId(),
                            item.getQuantity()
                    );
                    System.out.println("[CheckoutService] Removing cart item from DB for userId=" + userId
                            + ", product=" + item.getProductId()
                            + ", color=" + item.getColorId()
                            + ", size=" + item.getSizeId());
                    cartDao.removeItem(
                            handle,
                            userId,
                            item.getProductId(),
                            item.getColorId(),
                            item.getSizeId()
                    );
                }
            }

            return orderId;
        });
    }

    public void completeMomoPayment(int orderId, Map<String, CartItem> cart) {
        jdbi.useTransaction(handle -> {
            Map<String, BigDecimal> unitPrices = new HashMap<>();

            for (CartItem item : cart.values()) {
                if (item.getQuantity() <= 0) {
                    throw new RuntimeException("So luong san pham khong hop le");
                }
                unitPrices.put(item.getKey(), promotionService.parsePrice(item.getFinalPrice()));
            }

            orderDetailDao.insertOrderDetails(handle, orderId, cart, unitPrices);

            for (CartItem item : cart.values()) {
                variantDao.updateStock(
                        handle,
                        item.getProductId(),
                        item.getColorId(),
                        item.getSizeId(),
                        item.getQuantity()
                );
            }

            Integer userId = orderDao.findUserIdByOrderId(handle, orderId);
            if (userId != null) {
                for (CartItem item : cart.values()) {
                    System.out.println("[CheckoutService] (MoMo) Removing cart item from DB for userId=" + userId
                            + ", product=" + item.getProductId()
                            + ", color=" + item.getColorId()
                            + ", size=" + item.getSizeId());
                    cartDao.removeItem(
                            handle,
                            userId,
                            item.getProductId(),
                            item.getColorId(),
                            item.getSizeId()
                    );
                }
            }

            orderDao.updatePaymentStatus(handle, orderId, PaymentStatus.PAID);
        });
    }

    public void failMomoPayment(int orderId) {
        jdbi.useTransaction(handle -> orderDao.updatePaymentStatus(handle, orderId, PaymentStatus.FAILED));
    }

    /**
     * Sends an order confirmation email to the customer after a successful order placement.
     *
     * @param orderId The database order ID
     * @param paymentMethod The payment method used (COD or MOMO)
     */
    public void sendOrderConfirmationEmail(int orderId, PaymentMethod paymentMethod) {
        try {
            model.Order.Order order = jdbi.withHandle(handle -> {
                List<model.Order.Order> orders = orderDao.findWithFilter(orderId, null, null);
                return orders.isEmpty() ? null : orders.get(0);
            });
            if (order == null) {
                System.err.println("[CheckoutService] Order not found for email: orderId=" + orderId);
                return;
            }

            Integer userId = orderDao.findUserIdByOrderId(orderId);
            if (userId == null) {
                System.err.println("[CheckoutService] No userId found for orderId=" + orderId);
                return;
            }

            UserDao userDao = new UserDao();
            User user = userDao.findById(userId);
            if (user == null || user.getEmail() == null || user.getEmail().isBlank()) {
                System.err.println("[CheckoutService] User email not found for userId=" + userId);
                return;
            }

            List<model.Order.OrderDetailDTO> items = orderDetailDao.findByOrderId(orderId);

            String emailContent = EmailTemplateBuilder.buildOrderConfirmationEmail(
                    user.getFullName(),
                    String.valueOf(orderId),
                    items,
                    order.getSubTotal(),
                    order.getShippingFee(),
                    order.getGrandTotal(),
                    order.getShippingAddress(),
                    order.getPhoneNumber(),
                    paymentMethod.name(),
                    order.getCreatedAt()
            );

            EmailServices emailService = new EmailServices();
            boolean sent = emailService.send(
                    user.getEmail(),
                    "X\u00E1c nh\u1EADn \u0111\u01A1n h\u00E0ng ShopShoes #" + orderId,
                    emailContent
            );

            if (sent) {
                System.out.println("[CheckoutService] Order confirmation email sent to " + user.getEmail()
                        + " for order #" + orderId);
            } else {
                System.err.println("[CheckoutService] Failed to send order confirmation email to "
                        + user.getEmail() + " for order #" + orderId);
            }
        } catch (Exception e) {
            System.err.println("[CheckoutService] Error sending order confirmation email for orderId="
                    + orderId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}
