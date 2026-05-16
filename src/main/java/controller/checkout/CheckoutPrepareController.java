package controller.checkout;

import dao.product.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.User;
import services.cart.CartService;
import services.product.PromotionService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/pr-checkout")
public class CheckoutPrepareController extends HttpServlet {

    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final CartService cartService = new CartService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String mode = (String) session.getAttribute("checkoutMode");

        User user = (User) session.getAttribute("currentUser");
        if (user != null) {
            req.setAttribute("currentUser", user);
        }

        Map<String, CartItem> checkoutCart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
//        if ("BUY_NOW".equals(mode)) {
//            checkoutCart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
//        } else {
//            checkoutCart = (Map<String, CartItem>) session.getAttribute("cart");
//        }

        if (checkoutCart == null || checkoutCart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal subTotalRaw = cartService.calculateTotal(checkoutCart);
        BigDecimal shippingFeeRaw = (BigDecimal) session.getAttribute("shippingFeeRaw");
        BigDecimal grandTotalRaw = shippingFeeRaw == null ? subTotalRaw : subTotalRaw.add(shippingFeeRaw);

        req.setAttribute("cart", checkoutCart);
        req.setAttribute("subTotal", promotionService.formatVND(subTotalRaw));
        req.setAttribute("subTotalRaw", subTotalRaw);
        req.setAttribute("shippingFee", shippingFeeRaw == null ? "Chua xac dinh" : promotionService.formatVND(shippingFeeRaw));
        req.setAttribute("grandTotal", shippingFeeRaw == null ? "Chua xac dinh" : promotionService.formatVND(grandTotalRaw));

        Object checkoutErrorMsg = session.getAttribute("checkoutErrorMsg");
        if (checkoutErrorMsg != null) {
            req.setAttribute("errorMessage", checkoutErrorMsg.toString());
            session.removeAttribute("checkoutErrorMsg");
        }

        req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
    }
}
