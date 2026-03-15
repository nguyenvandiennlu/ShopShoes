package controller.cart;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/update")
public class CartUpdateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        Map<String, CartItem> cart =
                (Map<String, CartItem>) session.getAttribute("cart");

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

        if ("plus".equals(action)) {
            item.setQuantity(item.getQuantity() + 1);
        }

        if ("minus".equals(action)) {
            if (item.getQuantity() > 1) {
                item.setQuantity(item.getQuantity() - 1);
            }
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}

