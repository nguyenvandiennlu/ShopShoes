package controller.cart;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/remove")
public class CartRemoveController extends HttpServlet  {

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

        if (key != null && cart.containsKey(key)) {
            cart.remove(key);
        }
        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
