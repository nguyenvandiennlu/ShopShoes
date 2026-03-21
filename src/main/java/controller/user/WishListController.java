package controller.user;

import dao.user.WishlistDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.WishListService;

import java.io.IOException;

@WebServlet("/wishlist")
public class WishListController extends HttpServlet {

    private WishListService wishlistService;
    private WishlistDao wishlistDao;

    @Override
    public void init() {
        wishlistService = new WishListService();
        wishlistDao = new WishlistDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        int userId = user.getId();

        req.setAttribute(
                "wishlistProducts",
                wishlistService.getWishlistProducts(userId));

        req.getRequestDispatcher("/Wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        int userId = user.getId();
        int productId = Integer.parseInt(req.getParameter("productId"));

        String action = req.getParameter("action");

        if ("remove".equals(action)) {
            wishlistDao.remove(userId, productId);
            resp.sendRedirect(req.getContextPath() + "/wishlist");
        } else {
            wishlistDao.add(userId, productId);
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
        }
    }

}
