package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.cart.CartItem;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart/checkout-selected")
public class CheckoutSelectedController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart =
                (Map<String, CartItem>)
                        session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/cart"
            );

            return;
        }

        String[] selectedKeys =
                req.getParameterValues("selectedKeys");

        Map<String, CartItem> checkoutCart =
                new LinkedHashMap<>();

        if (selectedKeys == null || selectedKeys.length == 0) {

            checkoutCart.putAll(cart);

        } else {

            for (String key : selectedKeys) {

                CartItem item = cart.get(key);

                if (item != null) {
                    checkoutCart.put(key, item);
                }

            }
        }

        if (checkoutCart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/cart"
            );

            return;
        }

        session.setAttribute(
                "checkoutCart",
                checkoutCart
        );
        session.setAttribute("checkoutMode", "CART_SELECTED");

        resp.sendRedirect(
                req.getContextPath() + "/pr-checkout"
        );
    }
}
