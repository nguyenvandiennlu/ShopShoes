package controller.admin;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.product.ProductDao;
import dao.promotion.PromotionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion.Promotion;
import model.product.Product;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/promotions")
public class ManagePromotionsController extends HttpServlet {

    private PromotionDao promotionDao;
    private ProductDao productDao;

    @Override
    public void init() {
        promotionDao = new PromotionDao();
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("get-linked-products".equalsIgnoreCase(action)) {
            handleGetLinkedProducts(req, resp);
            return;
        }

        List<Promotion> promotionsList = promotionDao.findAll();
        List<Product> productsList = productDao.findAllActive();

        req.setAttribute("promotionsList", promotionsList);
        req.setAttribute("productsList", productsList);
        req.setAttribute("adminActive", "promotions");
        req.getRequestDispatcher("/admin/quanlykhuyenmai.jsp").forward(req, resp);
    }

    private void handleGetLinkedProducts(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            List<Integer> linkedIds = promotionDao.getLinkedProductIds(id);
            
            JsonArray array = new JsonArray();
            for (int pId : linkedIds) {
                array.add(pId);
            }
            out.print(array.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Invalid ID parameter");
            out.print(error.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            handleAddPromotion(req, resp);
        } else if ("edit".equalsIgnoreCase(action)) {
            handleEditPromotion(req, resp);
        } else if ("delete".equalsIgnoreCase(action)) {
            handleDeletePromotion(req, resp);
        } else if ("toggle".equalsIgnoreCase(action)) {
            handleToggleActive(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/promotions");
        }
    }

    private void handleAddPromotion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String name = req.getParameter("name");
            String discountType = req.getParameter("discount_type");
            String discountValueStr = req.getParameter("discount_value");
            String startDateStr = req.getParameter("start_date");
            String endDateStr = req.getParameter("end_date");
            boolean isActive = "on".equalsIgnoreCase(req.getParameter("is_active")) 
                    || "true".equalsIgnoreCase(req.getParameter("is_active"));

            BigDecimal discountValue = new BigDecimal(discountValueStr.trim());
            LocalDateTime startDate = null;
            if (startDateStr != null && !startDateStr.isBlank()) {
                startDate = LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }
            LocalDateTime endDate = null;
            if (endDateStr != null && !endDateStr.isBlank()) {
                endDate = LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }

            String[] productIdsParam = req.getParameterValues("productIds");
            List<Integer> productIds = new ArrayList<>();
            if (productIdsParam != null) {
                for (String pId : productIdsParam) {
                    productIds.add(Integer.parseInt(pId));
                }
            }

            Promotion promo = new Promotion();
            promo.setName(name);
            promo.setSlug(toSlug(name));
            promo.setDiscountType(discountType);
            promo.setDiscountValue(discountValue);
            promo.setStartDate(startDate);
            promo.setEndDate(endDate);
            promo.setActive(isActive);

            int generatedId = promotionDao.insert(promo, productIds);
            if (generatedId > 0) {
                req.getSession().setAttribute("successMsg", "Thêm khuyến mãi mới thành công!");
            } else {
                req.getSession().setAttribute("errorMsg", "Không thể thêm khuyến mãi. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }

    private void handleEditPromotion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String discountType = req.getParameter("discount_type");
            String discountValueStr = req.getParameter("discount_value");
            String startDateStr = req.getParameter("start_date");
            String endDateStr = req.getParameter("end_date");
            boolean isActive = "on".equalsIgnoreCase(req.getParameter("is_active")) 
                    || "true".equalsIgnoreCase(req.getParameter("is_active"));

            BigDecimal discountValue = new BigDecimal(discountValueStr.trim());
            LocalDateTime startDate = null;
            if (startDateStr != null && !startDateStr.isBlank()) {
                startDate = LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }
            LocalDateTime endDate = null;
            if (endDateStr != null && !endDateStr.isBlank()) {
                endDate = LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }

            String[] productIdsParam = req.getParameterValues("productIds");
            List<Integer> productIds = new ArrayList<>();
            if (productIdsParam != null) {
                for (String pId : productIdsParam) {
                    productIds.add(Integer.parseInt(pId));
                }
            }

            Promotion promo = new Promotion();
            promo.setId(id);
            promo.setName(name);
            promo.setSlug(toSlug(name));
            promo.setDiscountType(discountType);
            promo.setDiscountValue(discountValue);
            promo.setStartDate(startDate);
            promo.setEndDate(endDate);
            promo.setActive(isActive);

            boolean success = promotionDao.update(promo, productIds);
            if (success) {
                req.getSession().setAttribute("successMsg", "Cập nhật khuyến mãi thành công!");
            } else {
                req.getSession().setAttribute("errorMsg", "Cập nhật khuyến mãi thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }

    private void handleDeletePromotion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = promotionDao.delete(id);
            if (success) {
                req.getSession().setAttribute("successMsg", "Xóa khuyến mãi thành công!");
            } else {
                req.getSession().setAttribute("errorMsg", "Xóa khuyến mãi thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }

    private void handleToggleActive(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject json = new JsonObject();
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean isActive = Boolean.parseBoolean(req.getParameter("is_active"));
            
            boolean success = promotionDao.toggleActive(id, isActive);
            json.addProperty("success", success);
            if (!success) {
                json.addProperty("error", "Không thể cập nhật trạng thái");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("error", e.getMessage());
        }
        out.print(json.toString());
    }

    private String toSlug(String input) {
        if (input == null || input.isEmpty()) {
            return "";
        }
        String nonLatin = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD);
        String slug = nonLatin.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        slug = slug.toLowerCase()
            .replaceAll("[đĐ]", "d")
            .replaceAll("[^a-z0-9\\s-]", "")
            .replaceAll("\\s+", "-")
            .replaceAll("-+", "-")
            .replaceAll("^-|-$", "");
        return slug;
    }
}
