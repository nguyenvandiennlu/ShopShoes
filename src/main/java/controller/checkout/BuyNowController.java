package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.user.CartItem;
import services.cart.CartService;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/buy-now")
public class BuyNowController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int productId = Integer.parseInt(req.getParameter("productId"));
        int colorId   = Integer.parseInt(req.getParameter("colorId"));
        int sizeId    = Integer.parseInt(req.getParameter("sizeId"));
        int qty       = Integer.parseInt(req.getParameter("quantity"));

        Map<String, CartItem> checkoutCart = new LinkedHashMap<>();
        CartItem item = cartService.buildCartItem(productId, colorId, sizeId, qty);
        checkoutCart.put(item.getKey(), item);

        req.getSession().setAttribute("checkoutCart", checkoutCart);
//        req.getSession().setAttribute("checkoutMode", "BUY_NOW");

        resp.sendRedirect(req.getContextPath() + "/pr-checkout");
    }
}
