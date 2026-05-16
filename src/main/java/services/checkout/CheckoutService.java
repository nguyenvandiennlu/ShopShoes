package services.checkout;

import dao.JDBIConnector;
import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import dao.product.ProductVariantDao;
import enums.PaymentMethod;
import enums.PaymentStatus;
import model.cart.CartItem;
import org.jdbi.v3.core.Jdbi;
import services.product.PromotionService;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;


public class CheckoutService {

    private final ProductVariantDao variantDao = new ProductVariantDao();
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
            String orderNote
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
                    orderNote
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

            orderDao.updatePaymentStatus(handle, orderId, PaymentStatus.PAID);
        });
    }

    public void failMomoPayment(int orderId) {
        jdbi.useTransaction(handle -> orderDao.updatePaymentStatus(handle, orderId, PaymentStatus.FAILED));
    }
}
