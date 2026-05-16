package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import services.checkout.CheckoutService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/momo/ket-qua")
public class MomoReturnController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String orderIdRaw = req.getParameter("orderId");
        String resultCode = req.getParameter("resultCode");
        String message = req.getParameter("message");

        if (resultCode == null) {
            resultCode = req.getParameter("errorCode");
        }

        if (orderIdRaw == null || orderIdRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        int orderId;
        try {
            String normalizedOrderId = orderIdRaw.startsWith("ORD")
                    ? orderIdRaw.substring(3)
                    : orderIdRaw;
            orderId = Integer.parseInt(normalizedOrderId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        if (!"0".equals(resultCode)) {
            req.setAttribute("errorMessage", "Thanh toan MoMo that bai. " + (message == null ? "" : message));
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
            return;
        }

        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");
        Map<String, CartItem> pendingCart = (Map<String, CartItem>) session.getAttribute("pendingCheckoutCart");
        String pendingMode = (String) session.getAttribute("pendingCheckoutMode");

        try {
            if (pendingOrderId != null && pendingCart != null && pendingOrderId == orderId) {
                checkoutService.completeMomoPayment(orderId, pendingCart);

                if ("BUY_NOW".equals(pendingMode)) {
                    session.removeAttribute("checkoutCart");
                    session.removeAttribute("checkoutMode");
                } else {
                    session.removeAttribute("cart");
                }
                session.removeAttribute("shippingFeeRaw");
            }
        } catch (RuntimeException ignored) {
        }

        clearPending(session);
        session.setAttribute("successMessage", "Thanh toan MoMo thanh cong. Don hang da duoc ghi nhan!");
        resp.sendRedirect(req.getContextPath() + "/order-success");
    }

    private void clearPending(HttpSession session) {
        session.removeAttribute("pendingOrderId");
        session.removeAttribute("pendingCheckoutCart");
        session.removeAttribute("pendingCheckoutMode");
        session.removeAttribute("pendingShippingFeeRaw");
    }
}
