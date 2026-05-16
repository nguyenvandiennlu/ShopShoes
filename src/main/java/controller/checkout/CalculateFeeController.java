package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cart.CartItem;
import utils.Config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@WebServlet("/calculate-fee")
public class CalculateFeeController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        String toDistrictId = req.getParameter("district_id");
        String toWardCode = req.getParameter("ward_code");

        if (toDistrictId == null || toWardCode == null || toDistrictId.isEmpty() || toWardCode.isEmpty()) {
            session.removeAttribute("shippingFeeRaw");
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"Thieu thong tin dia chi\"}");
            return;
        }

        String mode = (String) session.getAttribute("checkoutMode");
        Map<String, CartItem> cart = "BUY_NOW".equals(mode)
                ? (Map<String, CartItem>) session.getAttribute("checkoutCart")
                : (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            session.removeAttribute("shippingFeeRaw");
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"Gio hang trong\"}");
            return;
        }

        int totalQuantity = cart.values().stream().mapToInt(CartItem::getQuantity).sum();
        int totalWeight = totalQuantity * 800;

        String ghnToken = Config.get("api.ghn");
        String shopId = Config.get("api.ghn.shopId");

        try {
            URL url = new URI(Config.get("api.ghn.fee")).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", ghnToken);
            conn.setRequestProperty("ShopId", shopId);
            conn.setDoOutput(true);

            String jsonInputString = String.format(
                    "{\"service_type_id\": 2, \"to_district_id\": %s, \"to_ward_code\": \"%s\", \"weight\": %d}",
                    toDistrictId, toWardCode, totalWeight
            );

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder responseText = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                responseText.append(responseLine.trim());
            }

            String responseStr = responseText.toString();
            int totalIndex = responseStr.indexOf("\"total\":");
            if (totalIndex != -1) {
                int commaIndex = responseStr.indexOf(",", totalIndex);
                if (commaIndex == -1) {
                    commaIndex = responseStr.indexOf("}", totalIndex);
                }

                String feeStr = responseStr.substring(totalIndex + 8, commaIndex).trim();
                BigDecimal fee = new BigDecimal(feeStr);
                session.setAttribute("shippingFeeRaw", fee);
                resp.getWriter().write("{\"status\":\"success\", \"fee\":" + feeStr + "}");
                return;
            }

            session.removeAttribute("shippingFeeRaw");
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"Loi phan hoi tu GHN\"}");
        } catch (Exception e) {
            session.removeAttribute("shippingFeeRaw");
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
