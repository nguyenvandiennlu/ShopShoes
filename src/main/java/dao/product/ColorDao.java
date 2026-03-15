
package dao.product;

import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Color;

public class ColorDao {

    private final Jdbi jdbi = JDBIConnector.getJdbi();


    // COLORS
    public List<Color> findAll()
    {
        String sql = """
                SELECT *
                FROM color
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Color.class)
                        .list()
        );
    }

    public Color findById(int id) {
        String sql = "SELECT * FROM color WHERE id = :id";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("id", id)
                .mapToBean(Color.class)
                .findOne().orElse(null));
    }

    public void insert(Color c) {
        String sql = """
                    INSERT INTO color(name, hexcode)
                    VALUES(:name, :hexcode)
                """;
        jdbi.useHandle(h -> h.createUpdate(sql).bindBean(c).execute());
    }

    public void delete(int id) {
        jdbi.useHandle(h -> h.createUpdate("UPDATE color SET is_active = 0 WHERE id = :id")
                .bind("id", id).execute());
    }

    public List<Color> findAllActive() {
        String sql = "SELECT * FROM color ORDER BY name";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .mapToBean(Color.class)
                .list());
    }
}
