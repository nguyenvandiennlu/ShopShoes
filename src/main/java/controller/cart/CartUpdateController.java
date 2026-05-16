package controller.cart;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import model.cart.CartItem; // nếu project bạn đang dùng model.user.CartItem thì đổi lại
import services.cart.CartService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/update")
public class CartUpdateController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String key = req.getParameter("key");
        String action = req.getParameter("action");

        CartItem item = cart.get(key);
        if (item == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            if ("plus".equals(action)) {
                item.setQuantity(item.getQuantity() + 1);
            }
            if ("minus".equals(action) && item.getQuantity() > 1) {
                item.setQuantity(item.getQuantity() - 1);
            }
            session.setAttribute("cart", cart);
        } else {
            cartService.syncUpdate(session, currentUser.getId(), key, action);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
