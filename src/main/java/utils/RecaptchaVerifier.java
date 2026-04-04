package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
public class RecaptchaVerifier {

    private static final String VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";
    private RecaptchaVerifier() {
    }
    public static String getSiteKey() {
        return Config.get("recaptcha.site.key", "");
    }
    public static boolean isConfigured() {
        String siteKey = Config.get("recaptcha.site.key", "");
        String secretKey = Config.get("recaptcha.secret.key", "");
        return !siteKey.isBlank() && !secretKey.isBlank() 
               && !siteKey.startsWith("YOUR_") && !secretKey.startsWith("YOUR_");
    }
    public static boolean verify(String recaptchaResponse) {
        if (!isConfigured()) {
            System.out.println("[reCAPTCHA] Keys not configured properly, skipping verification");
            return true;
        }
        if (recaptchaResponse == null || recaptchaResponse.isBlank()) {
            System.out.println("[reCAPTCHA] Token is null or empty");
            return false;
        }
        String secretKey = Config.get("recaptcha.secret.key", "");
        HttpURLConnection conn = null;
        try {
            URL url = new URL(VERIFY_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            String params = "secret=" + secretKey + "&response=" + recaptchaResponse;
            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes(StandardCharsets.UTF_8));
                os.flush();
            }
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[reCAPTCHA] HTTP error: " + responseCode);
                return false;
            }
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }
            System.out.println("[reCAPTCHA] Google response: " + response);
            JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
            boolean success = jsonResponse.has("success") && jsonResponse.get("success").getAsBoolean();
            if (!success && jsonResponse.has("error-codes")) {
                System.err.println("[reCAPTCHA] Error codes: " + jsonResponse.get("error-codes"));
            }
            return success;
        } catch (Exception e) {
            System.err.println("[reCAPTCHA] Exception: " + e.getMessage());
            return true;
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}
