package services.checkout;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import utils.MomoConfig;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class MomoSandboxService {

    private static final Gson GSON = new Gson();

    public static class MomoCreateResult {
        private final String payUrl;
        private final String deeplink;
        private final String qrCodeUrl;
        private final int resultCode;
        private final String message;

        public MomoCreateResult(String payUrl, String deeplink, String qrCodeUrl, int resultCode, String message) {
            this.payUrl = payUrl;
            this.deeplink = deeplink;
            this.qrCodeUrl = qrCodeUrl;
            this.resultCode = resultCode;
            this.message = message;
        }

        public String getPayUrl() {
            return payUrl;
        }

        public String getDeeplink() {
            return deeplink;
        }

        public String getQrCodeUrl() {
            return qrCodeUrl;
        }

        public int getResultCode() {
            return resultCode;
        }

        public String getMessage() {
            return message;
        }
    }

    public MomoCreateResult createPayment(String orderId, long amount, String orderInfo) {
        if (!MomoConfig.isSandboxConfigured()) {
            throw new RuntimeException("MoMo sandbox chua duoc cau hinh");
        }

        String endpoint = MomoConfig.getEndpoint();
        String partnerCode = MomoConfig.getPartnerCode();
        String accessKey = MomoConfig.getAccessKey();
        String secretKey = MomoConfig.getSecretKey();
        String requestType = MomoConfig.getRequestType();
        String redirectUrl = MomoConfig.getReturnUrl();
        String ipnUrl = MomoConfig.getIpnUrl();

        String requestId = UUID.randomUUID().toString();
        String extraData = "";

        String rawSignature = "accessKey=" + accessKey
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&ipnUrl=" + ipnUrl
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + partnerCode
                + "&redirectUrl=" + redirectUrl
                + "&requestId=" + requestId
                + "&requestType=" + requestType;

        String signature = hmacSha256(secretKey, rawSignature);

        JsonObject payload = new JsonObject();
        payload.addProperty("partnerCode", partnerCode);
        payload.addProperty("requestId", requestId);
        payload.addProperty("amount", String.valueOf(amount));
        payload.addProperty("orderId", orderId);
        payload.addProperty("orderInfo", orderInfo);
        payload.addProperty("redirectUrl", redirectUrl);
        payload.addProperty("ipnUrl", ipnUrl);
        payload.addProperty("lang", "vi");
        payload.addProperty("requestType", requestType);
        payload.addProperty("autoCapture", true);
        payload.addProperty("extraData", extraData);
        payload.addProperty("signature", signature);

        String responseText = postJson(endpoint, payload.toString());
        JsonObject response = GSON.fromJson(responseText, JsonObject.class);

        int resultCode = response.has("resultCode") ? response.get("resultCode").getAsInt() : -1;
        String message = response.has("message") ? response.get("message").getAsString() : "Khong ro phan hoi tu MoMo";
        String payUrl = response.has("payUrl") ? response.get("payUrl").getAsString() : "";
        String deeplink = response.has("deeplink") ? response.get("deeplink").getAsString() : "";
        String qrCodeUrl = response.has("qrCodeUrl") ? response.get("qrCodeUrl").getAsString() : "";

        return new MomoCreateResult(payUrl, deeplink, qrCodeUrl, resultCode, message);
    }

    private String postJson(String endpoint, String body) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8
            ));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        } catch (IOException e) {
            throw new RuntimeException("Khong goi duoc MoMo sandbox: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    public String hmacSha256(String secretKey, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA256");
            SecretKeySpec key = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            hmac.init(key);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : bytes) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (Exception e) {
            throw new RuntimeException("Khong tao duoc chu ky MoMo", e);
        }
    }

    public boolean verifySignature(
            String signatureReceived,
            String amount,
            String extraData,
            String message,
            String orderId,
            String orderInfo,
            String orderType,
            String partnerCode,
            String payType,
            String requestId,
            String responseTime,
            String resultCode,
            String transId
    ) {
        String accessKey = MomoConfig.getAccessKey();
        String secretKey = MomoConfig.getSecretKey();

        String rawSignature = "accessKey=" + accessKey
                + "&amount=" + amount
                + "&extraData=" + (extraData != null ? extraData : "")
                + "&message=" + (message != null ? message : "")
                + "&orderId=" + orderId
                + "&orderInfo=" + (orderInfo != null ? orderInfo : "")
                + "&orderType=" + (orderType != null ? orderType : "")
                + "&partnerCode=" + partnerCode
                + "&payType=" + (payType != null ? payType : "")
                + "&requestId=" + requestId
                + "&responseTime=" + responseTime
                + "&resultCode=" + resultCode
                + "&transId=" + transId;

        String calculatedSignature = hmacSha256(secretKey, rawSignature);
        return calculatedSignature.equalsIgnoreCase(signatureReceived);
    }
}
