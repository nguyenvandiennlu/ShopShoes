package utils;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
public class Config {
    private static Properties props = new Properties();
    
    static {
        try (InputStream input = Config.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input != null) {
                props.load(input);
                System.out.println("Config loaded");
            }
        } catch (IOException e) {
            System.out.println("Config error: " + e.getMessage());
        }
    }
    public static String get(String key, String defaultValue) {
        return props.getProperty(key, defaultValue);
    }
    
    public static String get(String key) {
        return props.getProperty(key);
    }
    
    public static int getInt(String key, int defaultValue) {
        try {
            return Integer.parseInt(props.getProperty(key, defaultValue + ""));
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
