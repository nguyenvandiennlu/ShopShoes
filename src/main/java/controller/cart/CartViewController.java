package controller.cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import model.user.User;
import services.cart.CartService;
import services.product.PromotionService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartViewController extends HttpServlet {

    private final CartService cartService = new CartService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Map<String, CartItem> cart =
                (Map<String, CartItem>) session.getAttribute("cart");
        if (currentUser != null) {
            cartService.loadDbCartToSession(session, currentUser.getId());
            cart = (Map<String, CartItem>) session.getAttribute("cart");
        }
        if(cart==null){
            cart = new LinkedHashMap<>();
        }

        request.setAttribute("cartItems", cart.values());

        BigDecimal total = cartService.calculateTotal(cart);

        request.setAttribute(
                "cartTotal",
                promotionService.formatVND(total)
        );

        request.getRequestDispatcher("/Carts.jsp").forward(request, response);
    }
}
