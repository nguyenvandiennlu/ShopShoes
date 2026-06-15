package controller.checkout;

import dao.order.OrderDetailDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order.OrderDetailDTO;
import model.cart.CartItem;
import model.user.User;
import services.cart.CartService;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/reorder")
public class ReorderController extends HttpServlet {

    private final CartService cartService = new CartService();
    private final OrderDetailDao orderDetailDao = new OrderDetailDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(req.getParameter("orderId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        // Get order details (productId, colorId, sizeId, quantity)
        List<OrderDetailDTO> items = orderDetailDao.findByOrderId(orderId);
        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        // Get the full detail rows with IDs from order_detail table
        List<model.Order.OrderDetail> orderDetails = orderDetailDao.findDetailByOrderId(orderId);

        Map<String, CartItem> reorderCart = new LinkedHashMap<>();

        for (model.Order.OrderDetail detail : orderDetails) {
            int productId = detail.getProductId();
            int colorId = detail.getColorId();
            int sizeId = detail.getSizeId();
            int qty = detail.getQuantity();

            // Build cart item with current prices (promotions may have changed)
            CartItem item = cartService.buildCartItem(productId, colorId, sizeId, qty);
            reorderCart.put(item.getKey(), item);
        }

        // Set session attributes for checkout
        session.setAttribute("checkoutCart", reorderCart);
        session.setAttribute("checkoutMode", "REORDER");

        resp.sendRedirect(req.getContextPath() + "/pr-checkout");
    }
}