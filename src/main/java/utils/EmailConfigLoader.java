package utils;


import java.io.InputStream;
import java.util.Properties;

public class EmailConfigLoader {

    private static final Properties props = new Properties();

    static {
        try (InputStream input = EmailConfigLoader.class
                .getClassLoader()
                .getResourceAsStream("email.properties")) {

            if (input == null) {
                throw new RuntimeException("Không tìm thấy file email.properties");
            }

            props.load(new java.io.InputStreamReader(input, java.nio.charset.StandardCharsets.UTF_8));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }

    public static synchronized boolean save(
            String host, String port, String username, String password,
            String auth, String starttls,
            String shopName, String shopHotline, String shopAddress, String shopEmail
    ) {
        props.setProperty("mail.host", host);
        props.setProperty("mail.port", port);
        props.setProperty("mail.username", username);
        props.setProperty("mail.password", password);
        props.setProperty("mail.auth", auth);
        props.setProperty("mail.starttls.enable", starttls);
        props.setProperty("mail.smtp.ssl.trust", host);
        
        if (shopName != null) props.setProperty("shop.name", shopName);
        if (shopHotline != null) props.setProperty("shop.hotline", shopHotline);
        if (shopAddress != null) props.setProperty("shop.address", shopAddress);
        if (shopEmail != null) props.setProperty("shop.email", shopEmail);

        try {
            java.net.URL resource = EmailConfigLoader.class.getClassLoader().getResource("email.properties");
            if (resource != null) {
                java.io.File file = new java.io.File(resource.toURI());
                try (java.io.OutputStreamWriter writer = new java.io.OutputStreamWriter(
                        new java.io.FileOutputStream(file), java.nio.charset.StandardCharsets.UTF_8)) {
                    props.store(writer, "Cập nhật từ trang Cài đặt Hệ thống Admin");
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}