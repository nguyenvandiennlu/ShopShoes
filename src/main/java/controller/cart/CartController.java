package controller.cart;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.cart.CartService;

import java.io.IOException;

@WebServlet("/cart/add")
public class CartController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();

        int productId = Integer.parseInt(req.getParameter("productId"));
        int colorId = Integer.parseInt(req.getParameter("colorId"));
        int qty = Integer.parseInt(req.getParameter("quantity"));

        String sizeRaw = req.getParameter("sizeId");
        if (sizeRaw == null || sizeRaw.isEmpty()) {
            resp.sendRedirect(
                    req.getContextPath() + "/product?id=" + productId);
            return;
        }

        int sizeId = Integer.parseInt(sizeRaw);

        cartService.addToCart(
                session,
                productId,
                colorId,
                sizeId,
                qty);

        // Redirect về trang sản phẩm với thông báo thành công
        resp.sendRedirect(req.getContextPath() + "/product?id=" + productId + "&colorId=" + colorId + "&sizeId="
                + sizeId + "&msg=cart_added");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/menu");
    }
}
