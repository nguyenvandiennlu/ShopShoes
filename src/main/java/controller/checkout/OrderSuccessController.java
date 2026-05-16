package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/order-success")
public class OrderSuccessController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Object flashMessage = session.getAttribute("successMessage");
        if (flashMessage != null) {
            req.setAttribute("successMessage", flashMessage.toString());
            session.removeAttribute("successMessage");
        }

        req.getRequestDispatcher("/OrderSuccess.jsp")
                .forward(req, resp);
    }
}

