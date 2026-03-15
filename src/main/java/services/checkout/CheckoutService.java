package services.checkout;

import dao.JDBIConnector;
import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import dao.product.ProductVariantDao;
import model.user.CartItem;
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

    public void placeOrder(
            int userId,
            Map<String, CartItem> cart,
            BigDecimal shippingFee
    ) {

        jdbi.useTransaction(handle -> {

            BigDecimal subTotal = BigDecimal.ZERO;
            Map<String, BigDecimal> unitPrices = new HashMap<>();

            for (CartItem item : cart.values()) {

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
                    grandTotal
            );

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
        });
    }
}