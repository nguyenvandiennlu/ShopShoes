package controller.checkout;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.checkout.CheckoutService;
import services.checkout.MomoSandboxService;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/momo/thong-bao")
public class MomoCallbackController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();
    private final MomoSandboxService momoSandboxService = new MomoSandboxService();

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

            String signature = json.has("signature") && !json.get("signature").isJsonNull() ? json.get("signature").getAsString() : "";
            String amount = json.has("amount") && !json.get("amount").isJsonNull() ? String.valueOf(json.get("amount").getAsLong()) : "";
            String extraData = json.has("extraData") && !json.get("extraData").isJsonNull() ? json.get("extraData").getAsString() : "";
            String message = json.has("message") && !json.get("message").isJsonNull() ? json.get("message").getAsString() : "";
            String orderIdRaw = json.has("orderId") && !json.get("orderId").isJsonNull() ? json.get("orderId").getAsString() : "";
            String orderInfo = json.has("orderInfo") && !json.get("orderInfo").isJsonNull() ? json.get("orderInfo").getAsString() : "";
            String orderType = json.has("orderType") && !json.get("orderType").isJsonNull() ? json.get("orderType").getAsString() : "";
            String partnerCode = json.has("partnerCode") && !json.get("partnerCode").isJsonNull() ? json.get("partnerCode").getAsString() : "";
            String payType = json.has("payType") && !json.get("payType").isJsonNull() ? json.get("payType").getAsString() : "";
            String requestId = json.has("requestId") && !json.get("requestId").isJsonNull() ? json.get("requestId").getAsString() : "";
            String responseTime = json.has("responseTime") && !json.get("responseTime").isJsonNull() ? String.valueOf(json.get("responseTime").getAsLong()) : "";
            String resultCode = json.has("resultCode") && !json.get("resultCode").isJsonNull() ? String.valueOf(json.get("resultCode").getAsInt()) : "";
            String transId = json.has("transId") && !json.get("transId").isJsonNull() ? String.valueOf(json.get("transId").getAsLong()) : "";

            boolean isValidSignature = momoSandboxService.verifySignature(
                    signature, amount, extraData, message, orderIdRaw, orderInfo,
                    orderType, partnerCode, payType, requestId, responseTime, resultCode, transId
            );

            if (!isValidSignature) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"message\":\"Chu ky xac thuc khong hop le\"}");
                return;
            }

            if (orderIdRaw != null && !orderIdRaw.isBlank()) {
                int orderId = parseOrderId(orderIdRaw);
                if ("0".equals(resultCode)) {
                    boolean isCompleted = checkoutService.completeMomoPayment(orderId);
                    if (isCompleted) {
                        checkoutService.sendOrderConfirmationEmail(orderId, enums.PaymentMethod.MOMO);
                    }
                } else {
                    checkoutService.failMomoPayment(orderId);
                }
            }
        } catch (Exception ex) {
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
