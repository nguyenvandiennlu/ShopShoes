package controller.order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.order.CancelOrderService;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/cancel-order")
public class CancelOrderController extends HttpServlet {

    private CancelOrderService cancelOrderService;

    @Override
    public void init() {
        cancelOrderService = new CancelOrderService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"Vui lòng đăng nhập để thực hiện chức năng này.\"}");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"Vui lòng đăng nhập để thực hiện chức năng này.\"}");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        String cancelReason = req.getParameter("cancelReason");

        if (orderIdStr == null || orderIdStr.isBlank()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"Mã đơn hàng không hợp lệ.\"}");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr.trim());
        } catch (NumberFormatException e) {
            resp.getWriter().print("{\"success\":false,\"message\":\"Mã đơn hàng không hợp lệ.\"}");
            return;
        }

        if (cancelReason == null || cancelReason.isBlank()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"Vui lòng nhập lý do hủy đơn hàng.\"}");
            return;
        }

        // Validate cancellation conditions
        String validationError = cancelOrderService.validateCancelOrder(orderId, currentUser.getId());
        if (validationError != null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"" + jsonEscape(validationError) + "\"}");
            return;
        }

        // Execute cancellation
        String cancelError = cancelOrderService.cancelOrder(orderId, cancelReason.trim());
        if (cancelError != null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"" + jsonEscape(cancelError) + "\"}");
            return;
        }

        // Check if refund notification is needed (for Momo payments)
        String refundNotification = cancelOrderService.getRefundNotification(orderId);

        PrintWriter out = resp.getWriter();
        if (refundNotification != null) {
            out.print("{\"success\":true,\"message\":\"Đơn hàng đã được hủy thành công.\",\"refundNotification\":\""
                    + jsonEscape(refundNotification) + "\"}");
        } else {
            out.print("{\"success\":true,\"message\":\"Đơn hàng đã được hủy thành công.\"}");
        }
    }

    private String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}