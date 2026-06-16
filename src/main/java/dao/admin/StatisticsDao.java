package dao.admin;

import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;
import java.time.LocalDateTime;

public class StatisticsDao {
    private final Jdbi jdbi = JDBIConnector.getJdbi();

    public int getTotalOrders(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COUNT(id) FROM orders WHERE created_at BETWEEN :start AND :end";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("start", start)
                .bind("end", end)
                .mapTo(Integer.class)
                .one());
    }

    public double getTotalRevenue(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COALESCE(SUM(grand_total), 0) FROM orders " +
                "WHERE order_status != 'CANCELLED' AND created_at BETWEEN :start AND :end";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("start", start)
                .bind("end", end)
                .mapTo(Double.class)
                .one());
    }

    public int getNewUsers(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COUNT(id) FROM users WHERE created_at BETWEEN :start AND :end";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("start", start)
                .bind("end", end)
                .mapTo(Integer.class)
                .one());
    }

    public int getLowStockCount() {
        String sql = "SELECT COUNT(DISTINCT product_id) FROM product_variant WHERE stock <= 5";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public int getTotalProducts() {
        String sql = "SELECT COUNT(id) FROM product WHERE is_discontinue = 0 AND is_available = 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public java.util.Map<java.time.LocalDate, Double> getRevenueByDay(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE(created_at) as d, COALESCE(SUM(grand_total), 0) as val FROM orders " +
                "WHERE order_status != 'CANCELLED' AND created_at BETWEEN :start AND :end GROUP BY DATE(created_at)";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getDate("d").toLocalDate(), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (java.time.LocalDate)a[0], a -> (Double)a[1])));
    }

    public java.util.Map<java.time.LocalDate, Double> getOrdersByDay(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE(created_at) as d, COUNT(id) as val FROM orders " +
                "WHERE created_at BETWEEN :start AND :end GROUP BY DATE(created_at)";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getDate("d").toLocalDate(), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (java.time.LocalDate)a[0], a -> (Double)a[1])));
    }

    public java.util.Map<java.time.LocalDate, Double> getQuantityByDay(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE(o.created_at) as d, COALESCE(SUM(d.quantity), 0) as val " +
                "FROM orders o JOIN order_detail d ON o.id = d.order_id " +
                "WHERE o.order_status != 'CANCELLED' AND o.created_at BETWEEN :start AND :end GROUP BY DATE(o.created_at)";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getDate("d").toLocalDate(), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (java.time.LocalDate)a[0], a -> (Double)a[1])));
    }

    public java.util.Map<String, Double> getRevenueByMonth(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') as m, COALESCE(SUM(grand_total), 0) as val FROM orders " +
                "WHERE order_status != 'CANCELLED' AND created_at BETWEEN :start AND :end GROUP BY DATE_FORMAT(created_at, '%Y-%m')";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getString("m"), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (String)a[0], a -> (Double)a[1])));
    }

    public java.util.Map<String, Double> getOrdersByMonth(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') as m, COUNT(id) as val FROM orders " +
                "WHERE created_at BETWEEN :start AND :end GROUP BY DATE_FORMAT(created_at, '%Y-%m')";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getString("m"), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (String)a[0], a -> (Double)a[1])));
    }

    public java.util.Map<String, Double> getQuantityByMonth(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT DATE_FORMAT(o.created_at, '%Y-%m') as m, COALESCE(SUM(d.quantity), 0) as val " +
                "FROM orders o JOIN order_detail d ON o.id = d.order_id " +
                "WHERE o.order_status != 'CANCELLED' AND o.created_at BETWEEN :start AND :end GROUP BY DATE_FORMAT(o.created_at, '%Y-%m')";
        return jdbi.withHandle(h -> h.createQuery(sql).bind("start", start).bind("end", end)
                .map((rs, ctx) -> new Object[]{rs.getString("m"), rs.getDouble("val")})
                .collect(java.util.stream.Collectors.toMap(a -> (String)a[0], a -> (Double)a[1])));
    }
}