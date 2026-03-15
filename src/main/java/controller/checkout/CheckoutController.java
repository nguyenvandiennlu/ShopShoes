package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.User;
import services.checkout.CheckoutService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();

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

        BigDecimal shippingFee =
                (BigDecimal) session.getAttribute("shippingFeeRaw");

        if (shippingFee == null) {
            shippingFee = BigDecimal.ZERO;
        }

        try {
            checkoutService.placeOrder(
                    user.getId(),
                    cart,
                    shippingFee
            );

            if ("BUY_NOW".equals(mode)) {
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutMode");
            } else {
                session.removeAttribute("cart");
            }

            session.removeAttribute("shippingFeeRaw");

            req.setAttribute("successMessage", "Đặt hàng thành công!");
            resp.sendRedirect(req.getContextPath() + "/order-success");

        } catch (RuntimeException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        }
    }
}
