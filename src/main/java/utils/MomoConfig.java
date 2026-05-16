package utils;

public class MomoConfig {

    private MomoConfig() {
    }

    public static String getPartnerCode() {
        return firstNonBlank(
                getWithEnvFallback("momo.partner.code", "MOMO_PARTNER_CODE"),
                Config.get("DEV_PARTNER_CODE", "")
        );
    }

    public static String getAccessKey() {
        return firstNonBlank(
                getWithEnvFallback("momo.access.key", "MOMO_ACCESS_KEY"),
                Config.get("DEV_ACCESS_KEY", "")
        );
    }

    public static String getSecretKey() {
        return firstNonBlank(
                getWithEnvFallback("momo.secret.key", "MOMO_SECRET_KEY"),
                Config.get("DEV_SECRET_KEY", "")
        );
    }

    public static String getEndpoint() {
        String explicit = getWithEnvFallback("momo.endpoint", "MOMO_ENDPOINT");
        if (!isBlank(explicit)) {
            return explicit;
        }

        String devBase = Config.get("DEV_MOMO_ENDPOINT", "").trim();
        String createUrl = Config.get("CREATE_URL", "").trim();
        if (!isBlank(devBase) && !isBlank(createUrl)) {
            return devBase + createUrl;
        }

        return devBase;
    }

    public static String getReturnUrl() {
        return getWithEnvFallback("momo.return.url", "MOMO_RETURN_URL");
    }

    public static String getIpnUrl() {
        return getWithEnvFallback("momo.ipn.url", "MOMO_IPN_URL");
    }

    public static String getRequestType() {
        return firstNonBlank(
                getWithEnvFallback("momo.request.type", "MOMO_REQUEST_TYPE"),
                "captureWallet"
        );
    }

    public static boolean isSandboxConfigured() {
        return !isBlank(getPartnerCode())
                && !isBlank(getAccessKey())
                && !isBlank(getSecretKey())
                && !isBlank(getEndpoint())
                && !isBlank(getReturnUrl())
                && !isBlank(getIpnUrl());
    }

    private static String getWithEnvFallback(String propKey, String envKey) {
        String env = System.getenv(envKey);
        if (!isBlank(env)) {
            return env.trim();
        }
        String prop = Config.get(propKey, "");
        return prop == null ? "" : prop.trim();
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private static String firstNonBlank(String first, String second) {
        return !isBlank(first) ? first : (second == null ? "" : second.trim());
    }
}
