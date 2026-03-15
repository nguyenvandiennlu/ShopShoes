package dao.product;

import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.product.Size;

public class SizeDao
{
    private final Jdbi jdbi = JDBIConnector.getJdbi();

    // SIZES
    public List<Size> findAll()
    {
        String sql = """
                SELECT *
                FROM size
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Size.class)
                        .list()
        );
    }

    public Size findById(int id)
    {
        String sql = "SELECT * FROM size WHERE id = :id";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Size.class)
                        .findOne().orElse(null)
        );
    }

    public void insert(Size size)
    {
        String sql = """
            INSERT INTO size(name, sort_order)
            VALUES(:name, :sort_order)
        """;
        jdbi.useHandle(h -> h.createUpdate(sql).bindBean(size).execute());
    }

    public void delete(int id)
    {
        jdbi.useHandle(h ->
                h.createUpdate("UPDATE size SET is_active = 0 WHERE id = :id")
                        .bind("id", id).execute()
        );
    }
    public List<Size> findAllActive()
    {
        String sql = "SELECT * FROM size ORDER BY sort_order";
        return jdbi.withHandle(h -> h.createQuery(sql)
                .mapToBean(Size.class)
                .list());
    }

}

