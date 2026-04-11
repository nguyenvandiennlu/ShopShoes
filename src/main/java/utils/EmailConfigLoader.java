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

            props.load(input);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}