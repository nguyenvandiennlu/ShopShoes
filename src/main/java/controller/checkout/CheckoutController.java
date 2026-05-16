package controller.checkout;

import enums.PaymentMethod;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.User;
import services.checkout.CheckoutService;
import services.checkout.MomoSandboxService;
import services.product.PromotionService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();
    private final MomoSandboxService momoSandboxService = new MomoSandboxService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String mode = (String) session.getAttribute("checkoutMode");
        Map<String, CartItem> cart;

        if ("BUY_NOW".equals(mode)) {
            cart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
        } else {
            cart = (Map<String, CartItem>) session.getAttribute("cart");
        }

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal shippingFee = (BigDecimal) session.getAttribute("shippingFeeRaw");
        if (shippingFee == null || shippingFee.compareTo(BigDecimal.ZERO) <= 0) {
            session.setAttribute("checkoutErrorMsg", "Vui long chon dia chi giao hang de tinh phi ship truoc khi dat hang.");
            resp.sendRedirect(req.getContextPath() + "/pr-checkout");
            return;
        }

        String rawPaymentMethod = req.getParameter("paymentMethod");
        PaymentMethod paymentMethod;
        try {
            paymentMethod = PaymentMethod.valueOf(
                    rawPaymentMethod == null ? "COD" : rawPaymentMethod.trim().toUpperCase()
            );
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", "Phuong thuc thanh toan khong hop le");
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
            return;
        }

        try {
            int orderId = checkoutService.placeOrder(
                    user.getId(),
                    cart,
                    shippingFee,
                    paymentMethod
            );

            if (paymentMethod == PaymentMethod.MOMO) {
                session.setAttribute("pendingOrderId", orderId);
                session.setAttribute("pendingCheckoutCart", cart);
                session.setAttribute("pendingCheckoutMode", mode);
                session.setAttribute("pendingShippingFeeRaw", shippingFee);

                long amount = calculateTotalAmount(cart, shippingFee);
                String momoOrderId = "ORD" + orderId;
                String orderInfo = "Thanh toan don hang ShopShoes #" + orderId;

                try {
                    MomoSandboxService.MomoCreateResult momoResult =
                            momoSandboxService.createPayment(momoOrderId, amount, orderInfo);

                    if (momoResult.getResultCode() == 0 && !momoResult.getPayUrl().isBlank()) {
                        resp.sendRedirect(momoResult.getPayUrl());
                        return;
                    }

                    req.setAttribute("errorMessage", "Khong tao duoc QR MoMo: " + momoResult.getMessage());
                    req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
                    return;
                } catch (RuntimeException ex) {
                    session.setAttribute("momoCreateError", ex.getMessage());
                    resp.sendRedirect(req.getContextPath() + "/momo/dev?orderId=" + orderId);
                }
                return;
            }

            if ("BUY_NOW".equals(mode)) {
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutMode");
            } else {
                session.removeAttribute("cart");
            }

            session.removeAttribute("shippingFeeRaw");
            session.setAttribute("successMessage", "Dat hang thanh cong! Don hang COD cho xu ly.");
            resp.sendRedirect(req.getContextPath() + "/order-success");

        } catch (RuntimeException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
        }
    }

    private long calculateTotalAmount(Map<String, CartItem> cart, BigDecimal shippingFee) {
        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            BigDecimal unitPrice = promotionService.parsePrice(item.getFinalPrice());
            subTotal = subTotal.add(unitPrice.multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return subTotal.add(shippingFee).longValue();
    }
}
