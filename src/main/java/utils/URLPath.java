package utils;

public class URLPath {
    public static boolean isStaticResource(String path) {
        String[] skipPatterns = {"/assets/", "/css/", "/js/", "/images/"};
        for (String pattern : skipPatterns) {
            if (path.contains(pattern)) return true;
        }
        return false;
    }
}
