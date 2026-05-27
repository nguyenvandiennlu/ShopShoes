package controller.product;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import DTO.ProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.product.ProductService;

/**
 * Controller xử lý hiển thị các sản phẩm đang có ưu đãi đặc biệt
 * 
 * URL pattern: /special-products
 */
@WebServlet("/special-products")
public class SpecialProductsController extends HttpServlet {

    private ProductService productService;
    private static final int PAGE_SIZE = 12;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy page number
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1)
                    page = 1;
            }
        } catch (Exception ignored) {
        }

        // Lấy danh sách tất cả sản phẩm có khuyến mại từ database
        List<ProductDTO> allProducts = productService.findAllProductsInPromotion();
        
        if (allProducts == null) {
            allProducts = Collections.emptyList();
        }

        // Tính tổng số trang
        int totalProducts = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        if (totalPages < 1)
            totalPages = 1;
        if (page > totalPages)
            page = totalPages;

        // Lấy sản phẩm của trang hiện tại
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalProducts);
        List<ProductDTO> productList = (startIndex < totalProducts && endIndex > startIndex)
                ? allProducts.subList(startIndex, endIndex)
                : Collections.emptyList();

        // Set attributes cho JSP
        req.setAttribute("productList", productList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("collectionName", "Ưu đãi đặc biệt");

        // Forward đến JSP
        req.getRequestDispatcher("/SpecialProducts.jsp").forward(req, resp);
    }
}
