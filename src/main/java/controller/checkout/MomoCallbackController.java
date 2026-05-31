package controller.checkout;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.checkout.CheckoutService;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/momo/thong-bao")
public class MomoCallbackController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"message\":\"Dung /momo/ket-qua cho trinh duyet\"}");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String contentType = req.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            handleIpnPost(req, resp);
            return;
        }
        doGet(req, resp);
    }

    private void handleIpnPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        StringBuilder body = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
        }

        try {
            JsonObject json = JsonParser.parseString(body.toString()).getAsJsonObject();
            String orderIdRaw = json.has("orderId") ? json.get("orderId").getAsString() : null;
            String resultCode = json.has("resultCode") ? String.valueOf(json.get("resultCode").getAsInt()) : null;

            if (orderIdRaw != null && !"0".equals(resultCode)) {
                int orderId = parseOrderId(orderIdRaw);
                checkoutService.failMomoPayment(orderId);
            }
        } catch (Exception ex) {
            System.out.println("[MomoCallbackController] IPN processing failed: " + ex.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"message\":\"Xu ly IPN MoMo that bai\"}");
            return;
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"message\":\"received\"}");
    }

    private int parseOrderId(String orderIdRaw) {
        String normalizedOrderId = orderIdRaw.startsWith("ORD")
                ? orderIdRaw.substring(3)
                : orderIdRaw;
        return Integer.parseInt(normalizedOrderId);
    }

}
