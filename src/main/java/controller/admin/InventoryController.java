package controller.admin;

import com.google.gson.Gson;
import dao.JDBIConnector;
import dao.admin.InventoryDao;
import dao.product.BrandDao;
import dao.product.ColorDao;
import model.admin.InventoryVariantRow;
import services.admin.InventoryService;
import services.admin.InventoryService.InventoryPageResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/inventory")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final InventoryDao     inventoryDao     = new InventoryDao();
    private final BrandDao         brandDao         = new BrandDao();
    private final ColorDao         colorDao         = new ColorDao();
    private final Gson             gson             = new Gson();

    /**
     * GET /admin/api/inventory
     *
     * action = "list" (default) | "filterOptions" | "variants"
     *
     * list        : keyword, brandId, colorId, sizeId, status, page
     * filterOptions: (không cần param)
     * variants    : productId
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");

            // ── variants: accordion detail cho 1 sản phẩm ───────────────────
            if ("variants".equals(action)) {
                Integer productId = parseIntOrNull(req.getParameter("productId"));
                if (productId == null) {
                    res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    res.getWriter().write("{\"error\":\"Thiếu productId.\"}");
                    return;
                }
                List<InventoryVariantRow> variants =
                        inventoryDao.findVariantsByProduct(productId);
                res.getWriter().write(gson.toJson(Map.of("variants", variants)));
                return;
            }

            // ── filterOptions: brand/color/size cho dropdown ─────────────────
            if ("filterOptions".equals(action)) {
                // Size không có SizeDao riêng — query thẳng
                var sizes = JDBIConnector.getJdbi().withHandle(h ->
                        h.createQuery("SELECT id, name FROM size ORDER BY sort_order, id")
                                .mapToMap()
                                .list());

                res.getWriter().write(gson.toJson(Map.of(
                        "brands", brandDao.findAllActive(),
                        "colors", colorDao.findAll(),
                        "sizes",  sizes
                )));
                return;
            }

            // ── list (default) ────────────────────────────────────────────────
            String  keyword     = req.getParameter("keyword");
            Integer brandId     = parseIntOrNull(req.getParameter("brandId"));
            Integer colorId     = parseIntOrNull(req.getParameter("colorId"));
            Integer sizeId      = parseIntOrNull(req.getParameter("sizeId"));
            String  stockStatus = req.getParameter("status");
            int     page        = parseIntOr(req.getParameter("page"), 1);

            InventoryPageResult result = inventoryService.getPage(
                    keyword, brandId, colorId, sizeId, stockStatus, page);

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