package controller.auth;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.auth.AuthService;
import utils.CookieUtil;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);

        if (session != null) {
            session.invalidate();
        }
        String rawToken = CookieUtil.getCookieValue(req, "REMEMBER_TOKEN");

        if (rawToken != null) {
            AuthService authService = new AuthService();
            authService.logoutFromDevice(rawToken);
            CookieUtil.removeCookie(resp, "REMEMBER_TOKEN");

            System.out.println("✓ [LogoutController] Remember Me token cleared.");
        }
        resp.sendRedirect(req.getContextPath() + "/menu");
    }
}
