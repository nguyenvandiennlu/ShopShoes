package controller.checkout;

import enums.PaymentMethod;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import dao.order.OrderDao;
import services.cart.CartService;
import services.checkout.CheckoutService;
import services.checkout.MomoSandboxService;
import utils.CheckoutSessionUtils;

import java.io.IOException;
import java.util.Map;

@WebServlet("/momo/ket-qua")
public class MomoReturnController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();
    private final CartService cartService = new CartService();
    private final OrderDao orderDao = new OrderDao();
    private final MomoSandboxService momoSandboxService = new MomoSandboxService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String orderIdRaw = req.getParameter("orderId");
        String resultCode = req.getParameter("resultCode");
        String message = req.getParameter("message");
        String signature = req.getParameter("signature");
        String amount = req.getParameter("amount");
        String extraData = req.getParameter("extraData");
        String orderInfo = req.getParameter("orderInfo");
        String orderType = req.getParameter("orderType");
        String partnerCode = req.getParameter("partnerCode");
        String payType = req.getParameter("payType");
        String requestId = req.getParameter("requestId");
        String responseTime = req.getParameter("responseTime");
        String transId = req.getParameter("transId");

        if (resultCode == null) {
            resultCode = req.getParameter("errorCode");
        }

        if (orderIdRaw == null || orderIdRaw.isBlank() || signature == null || signature.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        boolean isValidSignature = momoSandboxService.verifySignature(
                signature, amount, extraData, message, orderIdRaw, orderInfo,
                orderType, partnerCode, payType, requestId, responseTime, resultCode, transId
        );

        if (!isValidSignature) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            req.setAttribute("errorMessage", "Chu ky xac thuc giao dich MoMo khong hop le (Giao dich co the da bi gia mao)!");
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
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

        if (pendingOrderId == null || pendingCart == null || pendingOrderId != orderId) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        try {
            boolean isCompleted = checkoutService.completeMomoPayment(orderId);
            if (isCompleted) {
                checkoutService.sendOrderConfirmationEmail(orderId, PaymentMethod.MOMO);
            }

            Integer userId = orderDao.findUserIdByOrderId(orderId);
            if (!"BUY_NOW".equals(pendingMode) && userId != null) {
                CheckoutSessionUtils.removePurchasedAndReloadSession(session, pendingCart, cartService, userId);
            } else {
                CheckoutSessionUtils.clearCheckoutSession(session);
            }

            session.removeAttribute("shippingFeeRaw");
            CheckoutSessionUtils.clearPending(session);
            session.setAttribute("successMessage", "Thanh toan MoMo thanh cong. Don hang da duoc ghi nhan!");
            resp.sendRedirect(req.getContextPath() + "/order-success");
        } catch (RuntimeException ex) {
            CheckoutSessionUtils.clearAllCheckoutRelated(session);
            req.setAttribute("errorMessage", "Thanh toan MoMo thanh cong nhung xu ly don hang that bai: " + ex.getMessage());
            req.getRequestDispatcher("/Checkout.jsp").forward(req, resp);
        }
    }
}
