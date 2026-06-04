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

        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            if (isAjax) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập!\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        int userId = user.getId();
        int productId = Integer.parseInt(req.getParameter("productId"));

        String action = req.getParameter("action");

        try {
            if ("remove".equals(action)) {
                wishlistDao.remove(userId, productId);
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"success\":true,\"action\":\"removed\"}");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/wishlist");
                }
            } else {
                wishlistDao.add(userId, productId);
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"success\":true,\"action\":\"added\"}");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
            }
        }

    }

}
