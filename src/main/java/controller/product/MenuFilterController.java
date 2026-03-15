package controller.product;

import DTO.MenuDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.product.MenuService;

import java.io.IOException;

@WebServlet("/menufilter")
public class MenuFilterController extends HttpServlet {
    private MenuService homeService;

    @Override
    public void init() {
        homeService = new MenuService();
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String brandId = req.getParameter("brandId");

        if (brandId == null || brandId.isBlank()) {
            brandId = "all";
        }

        MenuDTO homePage;
        try {
            homePage = homeService.buildMenuPage(brandId);
        } catch (Exception e) {
            homePage = homeService.buildMenuPage("all");
        }

        req.setAttribute("menu", homePage);
        req.getRequestDispatcher("/menu.jsp").forward(req, resp);
    }
}
