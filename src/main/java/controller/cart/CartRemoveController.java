package controller.cart;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import model.user.User;
import services.cart.CartService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/remove")
public class CartRemoveController extends HttpServlet  {
    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession();
        Map<String,CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if(cart ==null){
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
    }
        String key = req.getParameter("key");
        if(key==null || key.isBlank()){
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        if(currentUser==null){
            cart.remove(key);
            session.setAttribute("cart", cart);

        }else{
            cartService.syncRemove(session,currentUser.getId(), key);

        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
