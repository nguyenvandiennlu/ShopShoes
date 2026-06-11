package controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import dao.JDBIConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/recent-reviews")
public class RecentReviewsController extends HttpServlet {

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
                        in.nextNull(); return null;
                    }
                    return LocalDateTime.parse(in.nextString(), DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                }
            })
            .serializeNulls()
            .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        try {
            String sql = """
                    SELECT
                        pr.id                   AS reviewId,
                        pr.rating               AS rating,
                        pr.content              AS content,
                        pr.created_at           AS createdAt,
                        pr.is_verified_purchase AS isVerifiedPurchase,
                        u.full_name             AS userName,
                        u.email                 AS userEmail,
                        p.name                  AS productName,
                        p.id                    AS productId,
                        pmi.img_url             AS productImg
                    FROM product_review pr
                    JOIN users u   ON u.id = pr.user_id
                    JOIN product p ON p.id = pr.product_id
                    LEFT JOIN product_main_img pmi ON pmi.product_id = p.id
                    ORDER BY pr.created_at DESC
                    LIMIT 5
                    """;

            List<Map<String, Object>> reviews = JDBIConnector.getJdbi()
                    .withHandle(h -> h.createQuery(sql).mapToMap().list());

            resp.getWriter().write(gson.toJson(reviews));

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}