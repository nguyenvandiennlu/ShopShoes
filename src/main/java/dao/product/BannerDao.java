package dao.product;

import dao.JDBIConnector;
import model.common.Banner;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BannerDao {

    private static final Jdbi jdbi = JDBIConnector.getJdbi();

    public static List<Banner> findByPositions(String position) {
        String sql = """
                    SELECT * FROM banner
                    WHERE position = :position
                      AND is_active = 1
                    ORDER BY sort_order
                """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("position", position)
                .mapToBean(Banner.class)
                .list());
    }

    public static Banner findByPosition(String position) {
        String sql = """
                    SELECT *
                    FROM banner
                    WHERE position = :position
                      AND is_active = 1
                    ORDER BY sort_order
                    LIMIT 1
                """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("position", position)
                .mapToBean(Banner.class)
                .findFirst()
                .orElse(null));
    }

    public void insert(Banner banner) {
        String sql = """
                    INSERT INTO banner(title, img_url, link_url,
                                       target_type, target_entity_id,
                                       position, sort_order, is_active, slogan)
                    VALUES(:title, :imgUrl, :linkUrl,
                           :targetType, :targetEntityId,
                           :position, :sortOrder, 1)
                """;

        jdbi.useHandle(h -> h.createUpdate(sql)
                .bindBean(banner)
                .execute());
    }

    public void delete(int id) {
        String sql = "UPDATE banner SET is_active = 0 WHERE id = :id";
        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }
    public List<Banner> findAll()
    {
        String sql = """
            SELECT *
            FROM banner
            ORDER BY sort_order ASC
        """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Banner.class)
                        .list()
        );
    }

    public void update(Banner banner) {
        String sql = """
        UPDATE banner SET
            title = :title,
            img_url = :img_url,
            link_url = :link_url,
            target_type = :target_type,
            target_entity_id = :target_entity_id,
            position = :position,
            sort_order = :sort_order,
            slogan = :slogan,
            is_active = :is_active,
            start_date = :start_date,
            end_date = :end_date
        WHERE id = :id
    """;

        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bind("id", banner.getId())
                        .bind("title", banner.getTitle())
                        .bind("img_url", banner.getImgUrl())
                        .bind("link_url", banner.getLinkUrl())
                        .bind("target_type", banner.getTargetType())
                        .bind("target_entity_id", banner.getTargetEntityId())
                        .bind("position", banner.getPosition())
                        .bind("sort_order", banner.getSortOrder())
                        .bind("slogan", banner.getSlogan())
                        .bind("is_active", banner.isActive()) // ⭐ QUAN TRỌNG
                        .bind("start_date", banner.getStartDate())
                        .bind("end_date", banner.getEndDate())
                        .execute()
        );
    }

    public Banner findById(int id)
    {
        String sql = "SELECT * FROM banner WHERE id = :id";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Banner.class)
                        .findOne()
                        .orElse(null)
        );
    }


    /**
     * Tìm banner theo collection ID
     * Dùng để hiển thị banner trên trang collection
     */
    public Banner findByCollectionId(int collectionId) {
        String sql = """
                    SELECT * FROM banner
                    WHERE target_type = 'COLLECTION'
                      AND target_entity_id = :collectionId
                      AND is_active = 1
                    LIMIT 1
                """;

        return jdbi.withHandle(h -> h.createQuery(sql)
                .bind("collectionId", collectionId)
                .mapToBean(Banner.class)
                .findFirst()
                .orElse(null));
    }
}


