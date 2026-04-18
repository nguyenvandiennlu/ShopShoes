package utils;

public class URLPath {
    public static boolean isStaticResource(String path) {
        String[] skipPatterns = {"/assets/", "/css/", "/js/", "/images/", "/vendors/"};
        for (String pattern : skipPatterns) {
            if (path.startsWith(pattern)) return true;
        }

        String lowerPath = path.toLowerCase();
        return lowerPath.endsWith(".css") ||
                lowerPath.endsWith(".js")  ||
                lowerPath.endsWith(".png") ||
                lowerPath.endsWith(".jpg") ||
                lowerPath.endsWith(".jpeg") ||
                lowerPath.endsWith(".svg") ||
                lowerPath.endsWith(".ico");
    }
}
