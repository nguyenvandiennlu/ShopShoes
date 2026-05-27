package controller.product;

import DTO.ProductDetailDTO;
import com.google.gson.Gson;
import dao.user.WishlistDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.user.User;
import services.product.ProductDetailService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/product")
public class ProductDetailController extends HttpServlet {

    private ProductDetailService productDetailService;
    private WishlistDao wishlistDao;

    @Override
    public void init() {
        productDetailService = new ProductDetailService();
        wishlistDao = new WishlistDao();
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

        ProductDetailDTO dto =
                productDetailService.buildProductDetailPage(
                        productId, colorId, sizeId
                );

        User user = (User) req.getSession().getAttribute("currentUser");

        boolean isInWishlist = false;
        if (user != null) {
            isInWishlist = wishlistDao.exists(user.getId(), productId);
        }

        req.setAttribute("product", dto);
        req.setAttribute("isInWishlist", isInWishlist);

        if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            resp.setContentType("application/json;charset=UTF-8");
            Map<String, Object> res = new HashMap<>();
            res.put("stock", dto.getStock());
            res.put("images", dto.getProductImg());
            res.put("sizes", dto.getProductSizeList());
            res.put("available", dto.getStock() > 0);
            resp.getWriter().write(new Gson().toJson(res));
        } else {
            req.setAttribute("product", dto);
            req.setAttribute("isInWishlist", isInWishlist);
            req.getRequestDispatcher("/ProductDetail.jsp").forward(req, resp);
        }
    }
}

