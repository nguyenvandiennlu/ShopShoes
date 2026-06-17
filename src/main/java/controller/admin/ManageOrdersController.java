package controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import model.Order.Order;
import model.Order.OrderDetailDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/orders")
public class ManageOrdersController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final OrderDetailDao orderDetailDao = new OrderDetailDao();
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private final DecimalFormat currencyFormat = new DecimalFormat("#,###");

    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new TypeAdapter<LocalDateTime>() {
                @Override
                public void write(JsonWriter out, LocalDateTime value) throws IOException {
                    if (value == null) out.nullValue();
                    else out.value(value.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                }

                @Override
                public LocalDateTime read(JsonReader in) throws IOException {
                    if (in.peek() == com.google.gson.stream.JsonToken.NULL) {
                        in.nextNull();
                        return null;
                    }
                    return LocalDateTime.parse(in.nextString(), DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                }
            }).create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pageParam = req.getParameter("page");
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        String paymentStatus = req.getParameter("paymentStatus");

        int page = 1;
        int pageSize = 10;

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Check if this is an AJAX request (JSON) or page load
        String requestedWith = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            handleAjaxRequest(resp, page, pageSize, search, status, paymentStatus);
            return;
        }

        // Regular page load - forward to JSP with data
        List<Order> orders = orderDao.findAllWithPaginationAndFilters(page, pageSize, search, status, paymentStatus);
        int totalCount = orderDao.countAll(search, status, paymentStatus);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("search", search != null ? search : "");
        req.setAttribute("status", status != null ? status : "all");
        req.setAttribute("paymentStatus", paymentStatus != null ? paymentStatus : "all");
        req.getRequestDispatcher("/admin/quanlydonhang.jsp").forward(req, resp);
    }

    private void handleAjaxRequest(HttpServletResponse resp, int page, int pageSize,
                                    String search, String status, String paymentStatus) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        List<Order> orders = orderDao.findAllWithPaginationAndFilters(page, pageSize, search, status, paymentStatus);
        int totalCount = orderDao.countAll(search, status, paymentStatus);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) totalPages = 1;

        JsonObject jsonResponse = new JsonObject();
        JsonArray ordersArray = new JsonArray();

        for (Order order : orders) {
            JsonObject jo = new JsonObject();
            jo.addProperty("id", order.getId());
            jo.addProperty("ordersId", order.getOrdersId() != null ? order.getOrdersId() : "#ORD-" + order.getId());
            jo.addProperty("recipientName", order.getRecipientName() != null ? order.getRecipientName() : "");
            jo.addProperty("recipientPhone", order.getRecipientPhone() != null ? order.getRecipientPhone() : order.getPhoneNumber());
            jo.addProperty("phoneNumber", order.getPhoneNumber() != null ? order.getPhoneNumber() : "");
            jo.addProperty("subTotal", order.getSubTotal() != null ? currencyFormat.format(order.getSubTotal()) : "0");
            jo.addProperty("shippingFee", order.getShippingFee() != null ? currencyFormat.format(order.getShippingFee()) : "0");
            jo.addProperty("grandTotal", order.getGrandTotal() != null ? currencyFormat.format(order.getGrandTotal()) : "0");
            jo.addProperty("orderStatus", order.getOrderStatus() != null ? order.getOrderStatus().name() : "NEW");
            jo.addProperty("paymentMethod", order.getPaymentMethod() != null ? order.getPaymentMethod().name() : "");
            jo.addProperty("paymentStatus", order.getPaymentStatus() != null ? order.getPaymentStatus().name() : "");
            jo.addProperty("shippingAddress", order.getShippingAddress() != null ? order.getShippingAddress() : "");
            jo.addProperty("province", order.getProvince() != null ? order.getProvince() : "");
            jo.addProperty("district", order.getDistrict() != null ? order.getDistrict() : "");
            jo.addProperty("ward", order.getWard() != null ? order.getWard() : "");
            jo.addProperty("street", order.getStreet() != null ? order.getStreet() : "");
            jo.addProperty("orderNote", order.getOrderNote() != null ? order.getOrderNote() : "");
            jo.addProperty("cancelReason", order.getCancelReason() != null ? order.getCancelReason() : "");
            jo.addProperty("createdAt", order.getCreatedAt() != null ? order.getCreatedAt().format(dateFormatter) : "");
            ordersArray.add(jo);
        }

        jsonResponse.add("orders", ordersArray);
        jsonResponse.addProperty("currentPage", page);
        jsonResponse.addProperty("totalPages", totalPages);
        jsonResponse.addProperty("totalCount", totalCount);

        resp.getWriter().write(jsonResponse.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        String action = req.getParameter("action");

        if ("updateStatus".equals(action)) {
            String orderIdParam = req.getParameter("orderId");
            String newStatus = req.getParameter("newStatus");

            if (orderIdParam == null || newStatus == null || newStatus.isBlank()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu tham số yêu cầu.");
                out.print(jsonResponse.toString());
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdParam);
                orderDao.updateOrderStatus(orderId, newStatus);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cập nhật trạng thái đơn hàng thành công!");
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ.");
            }
            out.print(jsonResponse.toString());

        } else if ("updatePaymentStatus".equals(action)) {
            String orderIdParam = req.getParameter("orderId");
            String newPaymentStatus = req.getParameter("newPaymentStatus");

            if (orderIdParam == null || newPaymentStatus == null || newPaymentStatus.isBlank()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu tham số yêu cầu.");
                out.print(jsonResponse.toString());
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdParam);
                orderDao.updatePaymentStatus(orderId, newPaymentStatus);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cập nhật trạng thái thanh toán thành công!");
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ.");
            }
            out.print(jsonResponse.toString());

        } else if ("getDetail".equals(action)) {
            String orderIdParam = req.getParameter("orderId");

            if (orderIdParam == null || orderIdParam.isBlank()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu ID đơn hàng.");
                out.print(jsonResponse.toString());
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdParam);
                Order order = orderDao.findById(orderId);
                if (order == null) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không tìm thấy đơn hàng.");
                    out.print(jsonResponse.toString());
                    return;
                }

                List<OrderDetailDTO> items = orderDetailDao.findByOrderId(orderId);

                JsonObject data = new JsonObject();
                data.addProperty("id", order.getId());
                data.addProperty("recipientName", order.getRecipientName() != null ? order.getRecipientName() : "");
                data.addProperty("recipientPhone", order.getRecipientPhone() != null ? order.getRecipientPhone() : order.getPhoneNumber());
                data.addProperty("shippingAddress", order.getShippingAddress() != null ? order.getShippingAddress() : "");
                data.addProperty("province", order.getProvince() != null ? order.getProvince() : "");
                data.addProperty("district", order.getDistrict() != null ? order.getDistrict() : "");
                data.addProperty("ward", order.getWard() != null ? order.getWard() : "");
                data.addProperty("street", order.getStreet() != null ? order.getStreet() : "");
                data.addProperty("phoneNumber", order.getPhoneNumber() != null ? order.getPhoneNumber() : "");
                data.addProperty("subTotal", order.getSubTotal() != null ? currencyFormat.format(order.getSubTotal()) : "0");
                data.addProperty("shippingFee", order.getShippingFee() != null ? currencyFormat.format(order.getShippingFee()) : "0");
                data.addProperty("grandTotal", order.getGrandTotal() != null ? currencyFormat.format(order.getGrandTotal()) : "0");
                data.addProperty("orderStatus", order.getOrderStatus() != null ? order.getOrderStatus().name() : "");
                data.addProperty("paymentMethod", order.getPaymentMethod() != null ? order.getPaymentMethod().name() : "");
                data.addProperty("paymentStatus", order.getPaymentStatus() != null ? order.getPaymentStatus().name() : "");
                data.addProperty("orderNote", order.getOrderNote() != null ? order.getOrderNote() : "");
                data.addProperty("cancelReason", order.getCancelReason() != null ? order.getCancelReason() : "");
                data.addProperty("createdAt", order.getCreatedAt() != null ? order.getCreatedAt().format(dateFormatter) : "");

                JsonArray itemsArray = new JsonArray();
                for (OrderDetailDTO item : items) {
                    JsonObject itemJo = new JsonObject();
                    itemJo.addProperty("productName", item.getProductName() != null ? item.getProductName() : "");
                    itemJo.addProperty("imageUrl", item.getImageUrl() != null ? item.getImageUrl() : "");
                    itemJo.addProperty("colorName", item.getColorName() != null ? item.getColorName() : "");
                    itemJo.addProperty("sizeName", item.getSizeName() != null ? item.getSizeName() : "");
                    itemJo.addProperty("quantity", item.getQuantity());
                    itemJo.addProperty("unitPrice", item.getUnitPrice() != null ? currencyFormat.format(item.getUnitPrice()) : "0");
                    itemJo.addProperty("subtotal", item.getUnitPrice() != null
                            ? currencyFormat.format(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity()))) : "0");
                    itemsArray.add(itemJo);
                }
                data.add("items", itemsArray);

                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", data);
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ.");
            }
            out.print(jsonResponse.toString());
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Hành động không hợp lệ.");
            out.print(jsonResponse.toString());
        }
    }
}