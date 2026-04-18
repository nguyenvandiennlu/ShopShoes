package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.auth.AuthService;
import utils.CookieUtil;
import utils.TokenGenerator;
import utils.URLPath;

import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {
    private AuthService authService;
    private static final String REMEMBER_TOKEN_COOKIE = "REMEMBER_TOKEN";
    private static final String SESSION_USER = "currentUser";

    @Override
    public void init(FilterConfig config) throws ServletException {
        System.out.println("✓ [AuthFilter] Initializing...");
        authService = new AuthService();
        System.out.println("✓ [AuthFilter] Initialized successfully");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestPath = httpRequest.getServletPath();

        if (URLPath.isStaticResource(requestPath)) {
            chain.doFilter(request, response);
            return;
        }

        try {
            HttpSession session = httpRequest.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute(SESSION_USER) : null;

            if (currentUser == null) {
                String rememberToken = CookieUtil.getCookieValue(httpRequest, REMEMBER_TOKEN_COOKIE);

                if (rememberToken != null && !rememberToken.isEmpty()) {

                    if (TokenGenerator.isValidTokenFormat(rememberToken)) {
                        User autoLoginUser = authService.getUserFromToken(rememberToken);

                        if (autoLoginUser != null) {
                            session = httpRequest.getSession(true);
                            session.setAttribute(SESSION_USER, autoLoginUser);
                            System.out.println("✓ [AuthFilter] Auto-login success for: " + autoLoginUser.getEmail());
                        } else {
                            System.out.println("→ [AuthFilter] Token expired or invalid in DB. Removing cookie.");
                            CookieUtil.removeCookie(httpResponse, REMEMBER_TOKEN_COOKIE);
                        }
                    } else {
                        System.out.println("→ [AuthFilter] Invalid token format. Removing cookie.");
                        CookieUtil.removeCookie(httpResponse, REMEMBER_TOKEN_COOKIE);
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("✗ [AuthFilter] Error in filter: " + e.getMessage());
            e.printStackTrace();
        }

        chain.doFilter(httpRequest, httpResponse);
    }
}
