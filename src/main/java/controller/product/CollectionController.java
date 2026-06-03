package controller.product;

import java.io.IOException;
import java.util.List;

import DTO.ProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Collection.Collection;
import services.product.CollectionService;

@WebServlet("/collection/*")
public class CollectionController extends HttpServlet {

    private CollectionService collectionService;
    // private BannerDao bannerDao; // TODO: BannerDao not found
    private static final int PAGE_SIZE = 12;

    @Override
    public void init() {
        collectionService = new CollectionService();
        // bannerDao = new BannerDao(); // TODO: BannerDao not found
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        String slug = pathInfo.substring(1); // Bỏ dấu "/" đầu tiên

        Collection collection = collectionService.findBySlug(slug);

        if (collection == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
            if (page < 1)
                page = 1;
        } catch (Exception ignored) {
        }

        String ruleSetType = collection.getRuleSetType();
        List<ProductDTO> productList = collectionService.getProductsInCollectionPaged(
                collection.getId(), ruleSetType, page, PAGE_SIZE);

        int totalPages = collectionService.getTotalPages(
                collection.getId(), ruleSetType, PAGE_SIZE);
        if (totalPages < 1)
            totalPages = 1;
        if (page > totalPages)
            page = totalPages;

        int totalProducts = collectionService.countProductsInCollection(
                collection.getId(), ruleSetType);

        // Banner banner = bannerDao.findByCollectionId(collection.getId()); // TODO: BannerDao not found

        req.setAttribute("collection", collection);
        req.setAttribute("productList", productList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("slug", slug);
        // req.setAttribute("banner", banner); // TODO: BannerDao not found

        req.getRequestDispatcher("/Collection.jsp").forward(req, resp);
    }
}
