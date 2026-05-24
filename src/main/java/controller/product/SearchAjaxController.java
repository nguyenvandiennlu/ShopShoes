package controller.product;

import DTO.ProductDTO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.product.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search-ajax")
public class SearchAjaxController extends HttpServlet {
    private ProductService productService;
    private static final int SUGGESTION_LIMIT = 5;
    private static final Gson gson = new Gson();

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("q");

        if (keyword == null || keyword.trim().isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }

        keyword = keyword.trim();
        
        try {
            List<ProductDTO> suggestions = productService.searchProducts(keyword, 1, SUGGESTION_LIMIT);

            Map<String, Object> response = new HashMap<>();
            response.put("suggestions", suggestions);
            response.put("totalResults", suggestions.size() > 0 ? 
                getEstimatedTotalResults(keyword) : 0);
            response.put("keyword", keyword);

            String jsonResponse = gson.toJson(response);
            resp.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Internal server error");
            String jsonError = gson.toJson(error);
            resp.getWriter().write(jsonError);
        }
    }

    private int getEstimatedTotalResults(String keyword) {
        try {
            int pageCount = productService.getSearchTotalPages(keyword, 12); // 12 items per page
            return Math.max(SUGGESTION_LIMIT, pageCount * 12);
        } catch (Exception e) {
            return 0;
        }
    }
}
