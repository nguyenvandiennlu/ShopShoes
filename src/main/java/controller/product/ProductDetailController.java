package controller.product;

import DTO.ProductDetailDTO;
import com.google.gson.Gson;
import dao.product.ProductReviewDao; // Đã thêm import
import dao.user.WishlistDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product.ProductReview; // Đã thêm import
import model.user.User;
import services.product.ProductDetailService;
import utils.ResourceNotFoundException;

import java.io.IOException;
import java.util.HashMap;
import java.util.List; // Đã thêm import
import java.util.Map;

@WebServlet("/product")
public class ProductDetailController extends HttpServlet {

    private ProductDetailService productDetailService;
    private WishlistDao wishlistDao;
    private ProductReviewDao reviewDao;

    @Override
    public void init() {
        productDetailService = new ProductDetailService();
        wishlistDao = new WishlistDao();
        reviewDao = new ProductReviewDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String productIdParam = req.getParameter("id");
        if (productIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        Integer colorId = null;
        try {
            if (req.getParameter("colorId") != null) {
                colorId = Integer.parseInt(req.getParameter("colorId"));
            }
        } catch (NumberFormatException ignored) {}

        Integer sizeId = null;
        try {
            if (req.getParameter("sizeId") != null) {
                sizeId = Integer.parseInt(req.getParameter("sizeId"));
            }
        } catch (NumberFormatException ignored) {}

        ProductDetailDTO dto = productDetailService.buildProductDetailPage(productId, colorId, sizeId);

        if (dto.getProductDTO() == null) {
            throw new ResourceNotFoundException("Product not found: " + productId);
        }

        User user = (User) req.getSession().getAttribute("currentUser");

        boolean isInWishlist = false;
        if (user != null) {
            isInWishlist = wishlistDao.exists(user.getId(), productId);
        }

        List<ProductReview> reviews = reviewDao.getReviewsByProductId(productId);

        int totalReviews = reviews.size();
        double averageRating = 0.0;
        int[] starCounts = new int[6];
        int[] starPercentages = new int[6];

        if (totalReviews > 0) {
            int sumRating = 0;
            for (ProductReview r : reviews) {
                sumRating += r.getRating();
                if (r.getRating() >= 1 && r.getRating() <= 5) {
                    starCounts[r.getRating()]++;
                }
            }
            averageRating = (double) sumRating / totalReviews;
            averageRating = Math.round(averageRating * 10) / 10.0;

            for (int i = 1; i <= 5; i++) {
                starPercentages[i] = (int) Math.round((double) starCounts[i] / totalReviews * 100);
            }
        }

        req.setAttribute("totalReviews", totalReviews);
        req.setAttribute("averageRating", totalReviews > 0 ? averageRating : 0.0);
        req.setAttribute("starPercentages", starPercentages);

        req.setAttribute("product", dto);
        req.setAttribute("isInWishlist", isInWishlist);
        req.setAttribute("reviews", reviews);

        if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            resp.setContentType("application/json;charset=UTF-8");
            Map<String, Object> res = new HashMap<>();
            res.put("stock", dto.getStock());
            res.put("images", dto.getProductImg());
            res.put("sizes", dto.getProductSizeList());
            res.put("available", dto.getStock() > 0);
            resp.getWriter().write(new Gson().toJson(res));
        } else {
            req.getRequestDispatcher("/ProductDetail.jsp").forward(req, resp);
        }
    }
}