package controller.checkout;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/buy-all")
public class BuyAllController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        session.removeAttribute("checkoutMode");
        session.removeAttribute("checkoutCart");
        session.removeAttribute("shippingFeeRaw");
        resp.sendRedirect(req.getContextPath() + "/pr-checkout");
    }
}
