package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.auth.TokenTypeService;
import java.io.IOException;

@WebServlet("/activate")
public class TokenTypeController extends HttpServlet {

   private TokenTypeService tokenTypeService;
    @Override
    public void init() {
        tokenTypeService = new TokenTypeService();  // Tạo instance service
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            resp.getWriter().println("Link kích hoạt không hợp lệ.");
            return;
        }
        boolean success = tokenTypeService.activateUserByToken(token);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login?activated=1");
        } else {
            resp.getWriter().println("Token không đúng hoặc đã hết hạn.");
        }
    }
}