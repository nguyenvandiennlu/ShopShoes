package controller.product;

import DTO.ProductDTO;
import dao.product.BrandDao;
import dao.product.ColorDao;
import dao.product.SizeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product.Brand;
import model.product.Color;
import model.product.Size;
import services.product.ProductService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/products")
public class ProductsController extends HttpServlet {

    private ProductService productService;
    private BrandDao brandDao;
    private SizeDao sizeDao;
    private ColorDao colorDao;
    private static final int PAGE_SIZE = 12;

    @Override
    public void init() {
        productService = new ProductService();
        brandDao = new BrandDao();
        sizeDao = new SizeDao();
        colorDao = new ColorDao();
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private BigDecimal parseBigDecimal(String s) {
        try {
            return new BigDecimal(s);
        } catch (Exception e) {
            return null;
        }
    }

    private List<Integer> parseIntArray(String[] arr) {
        List<Integer> list = new ArrayList<>();
        if (arr != null) {
            for (String s : arr) {
                try {
                    list.add(Integer.parseInt(s));
                } catch (Exception ignored) {
                }
            }
        }
        return list.isEmpty() ? null : list;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy các tham số filter
        String searchQuery = req.getParameter("q");
        int page = parseInt(req.getParameter("page"), 1);
        String sortBy = req.getParameter("sort"); // Thêm sort

        List<Integer> brandIds = parseIntArray(req.getParameterValues("brand"));
        List<Integer> sizeIds = parseIntArray(req.getParameterValues("size"));
        List<Integer> colorIds = parseIntArray(req.getParameterValues("color"));
        BigDecimal minPrice = parseBigDecimal(req.getParameter("minPrice"));
        BigDecimal maxPrice = parseBigDecimal(req.getParameter("maxPrice"));

        // Kiểm tra có filter nào không
        boolean hasFilter = (searchQuery != null && !searchQuery.trim().isEmpty())
                || brandIds != null || sizeIds != null || colorIds != null
                || minPrice != null || maxPrice != null || (sortBy != null && !sortBy.equals("default"));

        List<ProductDTO> productList;
        int totalPages;

        if (hasFilter) {
            // Có filter -> sử dụng filterProducts
            if (searchQuery != null)
                searchQuery = searchQuery.trim();

            totalPages = Math.max(1, productService.getFilteredTotalPages(
                    searchQuery, brandIds, sizeIds, colorIds, minPrice, maxPrice, PAGE_SIZE));

            if (page < 1)
                page = 1;
            if (page > totalPages)
                page = totalPages;

            productList = productService.filterProducts(
                    searchQuery, brandIds, sizeIds, colorIds, minPrice, maxPrice, sortBy, page, PAGE_SIZE);

            // Truyền các filter ra JSP để giữ trạng thái
            if (searchQuery != null && !searchQuery.isEmpty()) {
                req.setAttribute("searchQuery", searchQuery);
            }
            req.setAttribute("selectedBrands", brandIds);
            req.setAttribute("selectedSizes", sizeIds);
            req.setAttribute("selectedColors", colorIds);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("sortBy", sortBy);
        } else {
            // Không có filter -> hiển thị tất cả
            totalPages = Math.max(1, productService.getTotalPages(PAGE_SIZE));

            if (page < 1)
                page = 1;
            if (page > totalPages)
                page = totalPages;

            productList = productService.getProductsPage(page, PAGE_SIZE);
        }

        // Lấy danh sách brands, sizes, colors cho filter sidebar
        List<Brand> brands = brandDao.findAllActive();
        List<Size> sizes = sizeDao.findAllActive();
        List<Color> colors = colorDao.findAllActive();

        req.setAttribute("brands", brands);
        req.setAttribute("sizes", sizes);
        req.setAttribute("colors", colors);

        req.setAttribute("productList", productList);
        req.setAttribute("totalPages", totalPages);

        boolean isAjax = "1".equals(req.getParameter("ajax"));
        resp.setCharacterEncoding("UTF-8");
        if (isAjax) {
            req.getRequestDispatcher("/ProductsFragment.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/Products.jsp").forward(req, resp);
        }
    }
}