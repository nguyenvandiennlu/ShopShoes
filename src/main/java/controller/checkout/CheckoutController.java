package controller.checkout;

import enums.PaymentMethod;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import model.user.User;
import services.cart.CartService;
import services.checkout.CheckoutService;
import services.checkout.MomoSandboxService;
import services.product.PromotionService;
import services.user.AccountServices;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();
    private final MomoSandboxService momoSandboxService = new MomoSandboxService();
    private final PromotionService promotionService = new PromotionService();
    private final AccountServices accountServices = new AccountServices();
    private final CartService cartService = new CartService();

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
        boolean isBuyNow = "BUY_NOW".equals(mode);

        Map<String, CartItem> checkoutCart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
        Map<String, CartItem> cart = checkoutCart;
        if (cart == null || cart.isEmpty()) {
            cart = (Map<String, CartItem>) session.getAttribute("cart");
            isBuyNow = false;
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
        String phone = safe(req.getParameter("phone"));
        String address = safe(req.getParameter("address"));
        String note = safe(req.getParameter("note"));

        if (phone.isBlank() || address.isBlank()) {
            req.setAttribute("errorMessage", "Vui long nhap day du so dien thoai va dia chi giao hang.");
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
            return;
        }

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
                    paymentMethod,
                    address,
                    phone,
                    note
            );

            if (!address.equals(user.getAddress()) || !phone.equals(user.getPhoneNumber())) {
                accountServices.updateUserProfile(user.getId(), user.getFullName(), phone, address);
                user.setAddress(address);
                user.setPhoneNumber(phone);
                session.setAttribute("currentUser", user);
            }

            if (paymentMethod == PaymentMethod.MOMO) {
                session.setAttribute("pendingOrderId", orderId);
                session.setAttribute("pendingCheckoutCart", cart);
                session.setAttribute("pendingCheckoutMode", isBuyNow ? "BUY_NOW" : "CART_SELECTED");
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

            if (isBuyNow) {
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutMode");
            } else {
                cartService.loadDbCartToSession(session, user.getId());
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutMode");
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

    private String safe(String input) {
        return input == null ? "" : input.trim();
    }
}
