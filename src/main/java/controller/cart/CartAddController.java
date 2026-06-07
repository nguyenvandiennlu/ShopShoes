package controller.cart;

import dao.product.ProductDao;
import dao.product.ProductVariantDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.product.Product;
import services.cart.CartService;
import model.cart.CartItem;
import model.user.User;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/add")
public class CartAddController extends HttpServlet {

    private final CartService cartService = new CartService();
    private final ProductDao productDao = new ProductDao();
    private final ProductVariantDao variantDao = new ProductVariantDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        int productId, colorId, sizeId, qty;
        try {
            productId = Integer.parseInt(req.getParameter("productId"));
            colorId   = Integer.parseInt(req.getParameter("colorId"));
            qty       = Integer.parseInt(req.getParameter("quantity"));

            String sizeRaw = req.getParameter("sizeId");
            if (sizeRaw == null || sizeRaw.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                return;
            }
            sizeId = Integer.parseInt(sizeRaw);
        } catch (NumberFormatException e) {
            sendError(resp, isAjax, HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
            return;
        }

        if (qty <= 0 || qty > 100) {
            sendError(resp, isAjax, HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity");
            return;
        }

        Product product = productDao.findById(productId);
        if (product == null) {
            sendError(resp, isAjax, HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        if (!variantDao.existsProductVariant(productId, colorId, sizeId)) {
            sendError(resp, isAjax, HttpServletResponse.SC_BAD_REQUEST, "Invalid variant");
            return;
        }

        int stock = variantDao.getStock(productId, colorId, sizeId);
        String key = productId + "-" + colorId + "-" + sizeId;

        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        int currentQtyInCart = (cart != null && cart.containsKey(key))
                ? cart.get(key).getQuantity()
                : 0;

        if (currentQtyInCart + qty > stock) {
            sendError(resp, isAjax, HttpServletResponse.SC_CONFLICT,
                    "Not enough stock. Available: " + (stock - currentQtyInCart));
            return;
        }

        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                cartService.addToCart(session, productId, colorId, sizeId, qty);
            } else {
                cartService.syncAdd(session, currentUser.getId(), productId, colorId, sizeId, qty);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, isAjax, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
            return;
        }

        if (isAjax) {
            @SuppressWarnings("unchecked")
            Map<String, CartItem> updatedCart = (Map<String, CartItem>) session.getAttribute("cart");
            int cartCount = updatedCart == null ? 0
                    : updatedCart.values().stream().mapToInt(CartItem::getQuantity).sum();
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":true,\"cartCount\":" + cartCount + "}");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId
                    + "&colorId=" + colorId + "&sizeId=" + sizeId + "&msg=cart_added");
        }
    }

    private void sendError(HttpServletResponse resp, boolean isAjax,
                           int status, String message) throws IOException {
        resp.setStatus(status);
        if (isAjax) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false,\"error\":\"" + message + "\"}");
        } else {
            resp.sendError(status, message);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/menu");
    }
}
