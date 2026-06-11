package utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BreadcrumbGenerator {

    private static final Map<String, BreadcrumbItem> BREADCRUMB_MAP = new HashMap<>();

    static {
        // Mapping của các routes đến breadcrumb items
        BREADCRUMB_MAP.put("/menu", new BreadcrumbItem("Trang Chủ", "/menu", true));
        BREADCRUMB_MAP.put("/products", new BreadcrumbItem("Sản phẩm", "/products", true));
        BREADCRUMB_MAP.put("/product", new BreadcrumbItem("Chi tiết sản phẩm", "/product", false));
        BREADCRUMB_MAP.put("/gioi-thieu", new BreadcrumbItem("Giới thiệu", "/gioi-thieu", true));
        BREADCRUMB_MAP.put("/lien-he", new BreadcrumbItem("Liên hệ", "/lien-he", true));
        BREADCRUMB_MAP.put("/chinh-sach-bao-mat", new BreadcrumbItem("Chính sách bảo mật", "/chinh-sach-bao-mat", true));
        BREADCRUMB_MAP.put("/chinh-sach-bao-hanh", new BreadcrumbItem("Chính sách bảo hành", "/chinh-sach-bao-hanh", true));
        BREADCRUMB_MAP.put("/huong-dan-mua-hang", new BreadcrumbItem("Hướng dẫn mua hàng", "/huong-dan-mua-hang", true));
        BREADCRUMB_MAP.put("/faq", new BreadcrumbItem("FAQs", "/faq", true));
        BREADCRUMB_MAP.put("/login", new BreadcrumbItem("Đăng nhập", "/login", true));
        BREADCRUMB_MAP.put("/register", new BreadcrumbItem("Đăng ký", "/register", true));
        BREADCRUMB_MAP.put("/account", new BreadcrumbItem("Tài khoản", "/account", true));
        BREADCRUMB_MAP.put("/cart", new BreadcrumbItem("Giỏ hàng", "/cart", true));
        BREADCRUMB_MAP.put("/wishlist", new BreadcrumbItem("Danh sách yêu thích", "/wishlist", true));
        BREADCRUMB_MAP.put("/checkout", new BreadcrumbItem("Thanh toán", "/checkout", true));
        BREADCRUMB_MAP.put("/special-products", new BreadcrumbItem("Sản phẩm đặc biệt", "/special-products", true));
        BREADCRUMB_MAP.put("/collection", new BreadcrumbItem("Bộ sưu tập", "/collection", true));
    }

    public static List<BreadcrumbItem> generateBreadcrumb(String requestPath) {
        List<BreadcrumbItem> breadcrumb = new ArrayList<>();

        // Xử lý các path đặc biệt
        if (requestPath == null || requestPath.isEmpty() || requestPath.equals("/")) {
            breadcrumb.add(new BreadcrumbItem("Trang Chủ", "/menu", true));
            return breadcrumb;
        }

        // Loại bỏ leading slash
        String cleanPath = requestPath.startsWith("/") ? requestPath.substring(1) : requestPath;

        // Xử lý product detail
        if (cleanPath.startsWith("product")) {
            breadcrumb.add(new BreadcrumbItem("Sản phẩm", "/products", true));
            breadcrumb.add(new BreadcrumbItem("Chi tiết sản phẩm", null, false));
            return breadcrumb;
        }

        // Xử lý cart pages
        if (cleanPath.startsWith("cart")) {
            breadcrumb.add(new BreadcrumbItem("Giỏ hàng", "/cart", false));
            return breadcrumb;
        }

        // Xử lý checkout
        if (cleanPath.startsWith("checkout")) {
            breadcrumb.add(new BreadcrumbItem("Giỏ hàng", "/cart", true));
            breadcrumb.add(new BreadcrumbItem("Thanh toán", "/checkout", false));
            return breadcrumb;
        }

        // Xử lý collection
        if (cleanPath.startsWith("collection")) {
            breadcrumb.add(new BreadcrumbItem("Bộ sưu tập", "/collection", false));
            return breadcrumb;
        }

        // Tìm kiếm trong map
        for (String route : BREADCRUMB_MAP.keySet()) {
            if (cleanPath.startsWith(route.substring(1))) {
                BreadcrumbItem item = BREADCRUMB_MAP.get(route);
                breadcrumb.add(new BreadcrumbItem(item.label, item.url, item.isClickable));
                return breadcrumb;
            }
        }

        // Default case nếu không tìm thấy
        return breadcrumb;
    }

    public static class BreadcrumbItem {
        public String label;
        public String url;
        public boolean isClickable;

        public BreadcrumbItem(String label, String url, boolean isClickable) {
            this.label = label;
            this.url = url;
            this.isClickable = isClickable;
        }

        public String getLabel() {
            return label;
        }

        public String getUrl() {
            return url;
        }

        public boolean isClickable() {
            return isClickable;
        }
    }
}
