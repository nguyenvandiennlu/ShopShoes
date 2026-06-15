package controller.admin;

import DTO.ProductEditDTO;
import com.google.gson.Gson;
import dao.JDBIConnector;
import dao.admin.InventoryDao;
import dao.product.BrandDao;
import model.admin.InventoryVariantRow;
import services.admin.InventoryService;
import services.admin.InventoryService.InventoryPageResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/inventory")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final InventoryDao     inventoryDao     = new InventoryDao();
    private final BrandDao         brandDao         = new BrandDao();
    private final Gson             gson             = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");

            if ("variants".equals(action)) {
                Integer productId = parseIntOrNull(req.getParameter("productId"));
                if (productId == null) {
                    badRequest(res, "Thiếu productId."); return;
                }
                List<InventoryVariantRow> variants =
                        inventoryDao.findVariantsByProduct(productId);
                res.getWriter().write(gson.toJson(Map.of("variants", variants)));
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
                var sizes = JDBIConnector.getJdbi().withHandle(h ->
                        h.createQuery("SELECT id, name FROM size ORDER BY sort_order, id")
                                .mapToMap().list());
                var colors = JDBIConnector.getJdbi().withHandle(h ->
                        h.createQuery("SELECT id, name, hexcode FROM color ORDER BY name")
                                .mapToMap().list());
                res.getWriter().write(gson.toJson(Map.of(
                        "brands", brandDao.findAllActive(),
                        "colors", colors,
                        "sizes",  sizes
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