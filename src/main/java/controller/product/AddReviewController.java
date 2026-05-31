package controller.product;

import dao.product.ProductReviewDao;
import model.product.ProductReview;
import dao.order.OrderDao;
import model.user.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/add-review")
public class AddReviewController extends HttpServlet {

    private final ProductReviewDao reviewDao = new ProductReviewDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("currentUser");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (loggedInUser == null) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false, \"message\":\"Vui lòng đăng nhập trước khi đánh giá!\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        int productId = 0;
        boolean isVerified = false;

        try {
            productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            if (content != null) {
                content = content.trim();
            }

            if (content == null || content.isEmpty()) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":false, \"message\":\"Nội dung nhận xét không được để trống!\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
                }
                return;
            }
            isVerified = orderDao.checkUserPurchasedProduct(loggedInUser.getId(), productId);

            ProductReview review = new ProductReview();
            review.setProductId(productId);
            review.setUserId(loggedInUser.getId());
            review.setRating(rating);
            review.setContent(content);
            review.setVerifiedPurchase(isVerified);

            reviewDao.insertReview(review);

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false, \"error\":\"" + e.getMessage() + "\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }

        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true, \"message\":\"Cảm ơn bạn đã đánh giá sản phẩm này!\", \"verifiedPurchase\":" + isVerified + "}");
        } else {
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&msg=review_success");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}