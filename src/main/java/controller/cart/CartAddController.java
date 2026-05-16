package controller.cart;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.cart.CartService;
import model.user.User;

import java.io.IOException;

@WebServlet("/cart/add")
public class CartAddController extends HttpServlet {

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
        User currentUser = (User) session.getAttribute("currentUser") ;
        if(currentUser == null){
            cartService.addToCart(session, productId, colorId, sizeId, qty);

        }
        else{
            cartService.syncAdd(session,currentUser.getId(), productId, colorId, sizeId, qty);
        }
        resp.sendRedirect(req.getContextPath() + "/product?id=" + productId + "&colorId=" + colorId + "&sizeId="
                + sizeId + "&msg=cart_added");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/menu");
    }
}
