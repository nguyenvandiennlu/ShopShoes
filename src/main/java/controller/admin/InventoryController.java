package controller.admin;

import DTO.ProductEditDTO;
import com.google.gson.*;
import dao.JDBIConnector;
import dao.admin.InventoryDao;
import dao.product.BrandDao;
import dao.product.ColorDao;
import dao.product.SizeDao;
import model.admin.InventoryVariantRow;
import services.admin.InventoryService;
import services.admin.InventoryService.InventoryPageResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/inventory")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final InventoryDao     inventoryDao     = new InventoryDao();
    private final BrandDao         brandDao         = new BrandDao();
    private final SizeDao sizeDao = new SizeDao();
    private final ColorDao colorDao = new ColorDao();
    private final Gson             gson             = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");

            if ("variants".equals(action)) {
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));

                    String allParam = req.getParameter("all");
                    boolean includeDiscontinued = "true".equals(allParam);

                    List<InventoryVariantRow> variants = inventoryDao.findVariantsByProduct(productId, includeDiscontinued);

                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("variants", variants);
                    res.setContentType("application/json");
                    res.setCharacterEncoding("UTF-8");
                    res.getWriter().write(new Gson().toJson(responseMap));

                } catch (Exception e) {
                }
                return;
            }

            if ("productDetail".equals(action)) {
                Integer productId = parseIntOrNull(req.getParameter("productId"));
                if (productId == null) {
                    badRequest(res, "Thiếu productId."); return;
                }
                ProductEditDTO detail = inventoryDao.findProductDetail(productId);
                if (detail == null) {
                    badRequest(res, "Không tìm thấy sản phẩm."); return;
                }
                res.getWriter().write(gson.toJson(detail));
                return;
            }

            if ("filterOptions".equals(action)) {
                res.getWriter().write(gson.toJson(Map.of(
                        "brands", brandDao.findAllActive(),
                        "colors", colorDao.findAllActive(),
                        "sizes",  sizeDao.findAllActive()
                )));
                return;
            }

            String  keyword     = req.getParameter("keyword");
            Integer brandId     = parseIntOrNull(req.getParameter("brandId"));
            Integer colorId     = parseIntOrNull(req.getParameter("colorId"));
            Integer sizeId      = parseIntOrNull(req.getParameter("sizeId"));
            String  stockStatus = req.getParameter("status");
            String  visible     = req.getParameter("visible");
            int     page        = parseIntOr(req.getParameter("page"), 1);

            InventoryPageResult result = inventoryService.getPage(
                    keyword, brandId, colorId, sizeId, stockStatus, visible, page);

            res.getWriter().write(gson.toJson(Map.of(
                    "rows",        result.rows,
                    "totalCount",  result.totalCount,
                    "totalPages",  result.totalPages,
                    "currentPage", result.currentPage
            )));

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\":\"Lỗi hệ thống.\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");

            if ("updateProduct".equals(action)) {
                Integer productId = parseIntOrNull(req.getParameter("productId"));
                if (productId == null) {
                    badRequest(res, "Thiếu productId."); return;
                }

                String     name        = req.getParameter("name");
                BigDecimal price       = new BigDecimal(req.getParameter("price"));
                Integer    brandId     = parseIntOrNull(req.getParameter("brandId"));
                boolean    isAvailable = "1".equals(req.getParameter("isAvailable"))
                        || "true".equals(req.getParameter("isAvailable"));
                String     mainImgUrl  = req.getParameter("mainImgUrl");

                if (name == null || name.isBlank() || brandId == null) {
                    badRequest(res, "Thiếu thông tin bắt buộc."); return;
                }

                inventoryDao.updateProduct(productId, name.trim(), price, brandId,
                        isAvailable, mainImgUrl);

                res.getWriter().write("{\"success\":true}");
                return;
            }

            if ("saveRestock".equals(action)) {
                try {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    try (BufferedReader reader = req.getReader()) {
                        while ((line = reader.readLine()) != null) sb.append(line);
                    }

                    JsonObject data = JsonParser.parseString(sb.toString()).getAsJsonObject();
                    int productId = data.get("productId").getAsInt();
                    JsonArray updates = data.getAsJsonArray("updates");

                    for (JsonElement element : updates) {
                        JsonObject item = element.getAsJsonObject();
                        int variantId = item.get("variantId").getAsInt();
                        int qty = item.get("quantity").getAsInt();
                        inventoryDao.updateStock(variantId, productId, qty);
                    }

                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("success", true);
                    res.getWriter().write(gson.toJson(responseMap));

                } catch (Exception e) {
                    e.printStackTrace();
                    Map<String, Object> errorMap = new HashMap<>();
                    errorMap.put("success", false);
                    errorMap.put("message", "Lỗi server: " + e.getMessage());

                    res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    res.getWriter().write(gson.toJson(errorMap));
                }
                return;
            }

            if ("toggleVariantStatus".equals(action)) {
                try {
                    int variantId = Integer.parseInt(req.getParameter("variantId"));
                    boolean isDiscontinued = Boolean.parseBoolean(req.getParameter("isDiscontinued"));

                    inventoryDao.updateVariantStatus(variantId, isDiscontinued);

                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("success", true);

                    res.getWriter().write(gson.toJson(responseMap));
                } catch (Exception e) {
                    e.printStackTrace();
                    Map<String, Object> errorMap = new HashMap<>();
                    errorMap.put("success", false);
                    errorMap.put("message", "Lỗi server: " + e.getMessage());

                    res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    res.getWriter().write(gson.toJson(errorMap));
                }
                return;
            }

            if ("addVariant".equals(action)) {
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int colorId = Integer.parseInt(req.getParameter("colorId"));
                    int sizeId = Integer.parseInt(req.getParameter("sizeId"));
                    int stock = Integer.parseInt(req.getParameter("stock"));
                    String imageUrlsJson = req.getParameter("imageUrls");

                    if (inventoryDao.checkVariantExists(productId, colorId, sizeId)) {
                        Map<String, Object> responseMap = new HashMap<>();
                        responseMap.put("success", false);
                        responseMap.put("message", "Biến thể với Màu và Kích cỡ này đã tồn tại! Vui lòng kiểm tra lại trong danh sách Đang bán hoặc Ngừng bán.");
                        res.getWriter().write(gson.toJson(responseMap));
                        return;
                    }

                    inventoryDao.insertVariant(productId, colorId, sizeId, stock);

                    if (imageUrlsJson != null && !imageUrlsJson.trim().isEmpty()) {
                        java.lang.reflect.Type listType = new com.google.gson.reflect.TypeToken<List<String>>(){}.getType();
                        List<String> imageUrls = gson.fromJson(imageUrlsJson, listType);

                        if (imageUrls != null && !imageUrls.isEmpty()) {
                            int currentSortOrder = inventoryDao.getMaxSortOrder(productId, colorId);

                            for (String url : imageUrls) {
                                currentSortOrder++;
                                inventoryDao.insertProductImage(productId, colorId, url, currentSortOrder);
                            }
                        }
                    }

                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("success", true);
                    res.getWriter().write(gson.toJson(responseMap));

                } catch (Exception e) {
                    e.printStackTrace();
                    Map<String, Object> errorMap = new HashMap<>();
                    errorMap.put("success", false);
                    errorMap.put("message", "Lỗi server: " + e.getMessage());

                    res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    res.getWriter().write(gson.toJson(errorMap));
                }
                return;
            }

            badRequest(res, "Action không hợp lệ.");

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\":\"Lỗi hệ thống.\"}");
        }
    }

    private void badRequest(HttpServletResponse res, String msg) throws IOException {
        res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        res.getWriter().write("{\"error\":\"" + msg + "\"}");
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Integer.parseInt(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private int parseIntOr(String s, int fallback) {
        if (s == null || s.isBlank()) return fallback;
        try { return Integer.parseInt(s.trim()); }
        catch (NumberFormatException e) { return fallback; }
    }


}