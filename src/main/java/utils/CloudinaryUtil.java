package utils;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryUtil {

    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", getConfig("cloudinary.cloud_name", "CLOUDINARY_CLOUD_NAME"),
                "api_key", getConfig("cloudinary.api_key", "CLOUDINARY_API_KEY"),
                "api_secret", getConfig("cloudinary.api_secret", "CLOUDINARY_API_SECRET"),
                "secure", true
        ));
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }

    private static String getConfig(String propKey, String envKey) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }
        return Config.get(propKey, "");
    }
}
