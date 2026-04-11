package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.auth.AuthService;
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

        String requestPath = httpRequest.getRequestURI();
        if (URLPath.isStaticResource(requestPath)) {
            return;
        }
        try {
            System.out.println("→ [AuthFilter] Processing request: " + httpRequest.getRequestURI());

            String rememberToken = getCookieValue(httpRequest, REMEMBER_TOKEN_COOKIE);

            if (rememberToken != null && !rememberToken.isEmpty()) {
                System.out.println("→ [AuthFilter] Found REMEMBER_TOKEN cookie");

                if (authService.validateToken(rememberToken)) {
                    System.out.println("✓ [AuthFilter] Token is valid");

                    User user = authService.getUserFromToken(rememberToken);

                    if (user != null) {
                        System.out.println("✓ [AuthFilter] User retrieved: " + user.getEmail());

                        HttpSession session = httpRequest.getSession(true);
                        session.setAttribute(SESSION_USER, user);

                        System.out.println("✓ [AuthFilter] Session created/restored for user: " + user.getEmail());
                    } else {
                        System.err.println("✗ [AuthFilter] Could not get user from token");
                        removeCookie(httpResponse, REMEMBER_TOKEN_COOKIE);
                    }
                } else {
                    System.err.println("✗ [AuthFilter] Token is invalid or expired");

                    removeCookie(httpResponse, REMEMBER_TOKEN_COOKIE);
                    System.out.println("→ [AuthFilter] Cookie removed");
                }
            } else {
                System.out.println("→ [AuthFilter] No REMEMBER_TOKEN cookie found");
            }

        } catch (Exception e) {
            System.err.println("✗ [AuthFilter] Error in filter: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("→ [AuthFilter] Passing request to next filter/servlet");
        chain.doFilter(httpRequest, httpResponse);
    }

    private String getCookieValue(HttpServletRequest request, String cookieName) {
        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookieName.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }

        return null;
    }

    private void removeCookie(HttpServletResponse response, String cookieName) {
        Cookie cookie = new Cookie(cookieName, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
