package controller.product;

import DTO.ProductDetailDTO;
import DTO.ProductDTO;
import com.google.gson.Gson;
import dao.product.ProductReviewDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.product.ProductDetailService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/product/quick-view")
public class QuickViewController extends HttpServlet {

    private ProductDetailService productDetailService;
    private ProductReviewDao reviewDao;

    @Override
    public void init() {
        productDetailService = new ProductDetailService();
        reviewDao = new ProductReviewDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String productIdParam = req.getParameter("id");
        if (productIdParam == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing product id\"}");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid product id\"}");
            return;
        }

        try {
            ProductDetailDTO dto = productDetailService.buildProductDetailPage(productId, null, null);

            if (dto.getProductDTO() == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\":\"Product not found\"}");
                return;
            }

            ProductDTO p = dto.getProductDTO();

            // Get average rating
            var reviews = reviewDao.getReviewsByProductId(productId);
            double avgRating = 0.0;
            int totalReviews = reviews.size();
            if (totalReviews > 0) {
                int sum = reviews.stream().mapToInt(r -> r.getRating()).sum();
                avgRating = Math.round((double) sum / totalReviews * 10) / 10.0;
            }

            // Build colors list with hexCode
            List<Map<String, Object>> colors = dto.getProductColorList().stream()
                    .map(c -> {
                        Map<String, Object> colorMap = new HashMap<>();
                        colorMap.put("id", c.getId());
                        colorMap.put("name", c.getName());
                        colorMap.put("hexCode", c.getHexCode());
                        colorMap.put("selected", c.getId() == dto.getCurrentColorId());
                        return colorMap;
                    })
                    .collect(java.util.stream.Collectors.toList());

            // Build sizes list
            List<Map<String, Object>> sizes = dto.getProductSizeList().stream()
                    .map(s -> {
                        Map<String, Object> sizeMap = new HashMap<>();
                        sizeMap.put("id", s.getId());
                        sizeMap.put("name", s.getName());
                        sizeMap.put("selected", s.getId() == dto.getCurrentSizeId());
                        return sizeMap;
                    })
                    .collect(java.util.stream.Collectors.toList());

            // Get short description (first 150 chars)
            String description = dto.getProductDes();
            String shortDescription = description != null && description.length() > 150
                    ? description.substring(0, 150) + "..."
                    : description;

            Map<String, Object> result = new HashMap<>();
            result.put("id", p.getId());
            result.put("name", p.getName());
            result.put("price", p.getPrice());
            result.put("finalPrice", p.getFinalPrice());
            result.put("discountValue", p.getDiscountValue());
            result.put("mainImageUrl", p.getMainImageUrl());
            result.put("image", p.getMainImageUrl());
            result.put("description", description);
            result.put("shortDescription", shortDescription);
            result.put("stock", dto.getStock());
            result.put("averageRating", avgRating);
            result.put("totalReviews", totalReviews);
            result.put("colors", colors);
            result.put("sizes", sizes);

            resp.getWriter().write(new Gson().toJson(result));

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Server error\"}");
            e.printStackTrace();
        }
    }
}