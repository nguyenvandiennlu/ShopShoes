package utils;

import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import services.cart.CartService;
import java.util.Map;

public final class CheckoutSessionUtils {

    private CheckoutSessionUtils() {}

    public static void clearPending(HttpSession session) {
        if (session == null) return;
        session.removeAttribute("pendingOrderId");
        session.removeAttribute("pendingCheckoutCart");
        session.removeAttribute("pendingCheckoutMode");
        session.removeAttribute("pendingShippingFeeRaw");
    }

    public static void clearCheckoutSession(HttpSession session) {
        if (session == null) return;
        session.removeAttribute("checkoutCart");
        session.removeAttribute("checkoutMode");
        session.removeAttribute("shippingFeeRaw");
        session.removeAttribute("checkoutErrorMsg");
    }

    public static void clearAllCheckoutRelated(HttpSession session) {
        clearPending(session);
        clearCheckoutSession(session);
    }

    public static void removePurchasedAndReloadSession(HttpSession session,
                                                      Map<String, CartItem> purchasedCart,
                                                      CartService cartService,
                                                      Integer userId) {
        if (session == null) return;
        Object raw = session.getAttribute("cart");
        int before = (raw instanceof java.util.Map) ? ((java.util.Map<?, ?>) raw).size() : -1;
        int purchased = (purchasedCart == null) ? 0 : purchasedCart.size();
        System.out.println("[CheckoutSessionUtils] before removal - session cart size = " + before + ", purchasedCart size = " + purchased);

        if (purchasedCart != null && !purchasedCart.isEmpty()) {
            cartService.removePurchasedItemsFromSession(session, purchasedCart);
        }

        if (userId != null) {
            cartService.loadDbCartToSession(session, userId);
        }

        Object rawAfter = session.getAttribute("cart");
        int after = (rawAfter instanceof java.util.Map) ? ((java.util.Map<?, ?>) rawAfter).size() : -1;
        System.out.println("[CheckoutSessionUtils] after reload - session cart size = " + after);

        clearCheckoutSession(session);
    }
}





