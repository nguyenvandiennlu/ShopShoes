package dao.collection;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import model.Collection.CollectionRule;
import model.product.Product;

public class CollectionRuleDao {

    private final Jdbi jdbi;

    public static final String OP_EQUALS = "=";
    public static final String OP_NOT_EQUALS = "!=";
    public static final String OP_LESS_THAN = "<";
    public static final String OP_GREATER_THAN = ">";
    public static final String OP_LESS_EQUALS = "<=";
    public static final String OP_GREATER_EQUALS = ">=";
    public static final String OP_CONTAINS = "contains";
    public static final String OP_STARTS_WITH = "starts_with";
    public static final String OP_ENDS_WITH = "ends_with";


    public static final String FIELD_PRICE = "price";
    public static final String FIELD_BRAND_ID = "brand_id";
    public static final String FIELD_NAME = "name";
    public static final String FIELD_CATEGORY_ID = "category_id";

    public CollectionRuleDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }


    public List<CollectionRule> findByCollectionId(int collectionId) {
        String sql = """
                    SELECT * FROM collection_rule
                    WHERE collection_id = :collectionId
                    ORDER BY id
                """;

        try {
            return jdbi.withHandle(h -> h.createQuery(sql)
                    .bind("collectionId", collectionId)
                    .mapToBean(CollectionRule.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }



    public int insert(CollectionRule rule) {
        String sql = """
                    INSERT INTO collection_rule (collection_id, fieldName, operator, value)
                    VALUES (:collectionId, :fieldName, :operator, :value)
                """;

        try {
            return jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", rule.getCollectionId())
                    .bind("fieldName", rule.getFieldName())
                    .bind("operator", rule.getOperator())
                    .bind("value", rule.getValue())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(int.class)
                    .one());
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }


    public boolean update(CollectionRule rule) {
        String sql = """
                    UPDATE collection_rule
                    SET fieldName = :fieldName, operator = :operator, value = :value
                    WHERE id = :id
                """;

        try {
            int updated = jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("id", rule.getId())
                    .bind("fieldName", rule.getFieldName())
                    .bind("operator", rule.getOperator())
                    .bind("value", rule.getValue())
                    .execute());
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int ruleId) {
        String sql = "DELETE FROM collection_rule WHERE id = :id";

        try {
            int deleted = jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("id", ruleId)
                    .execute());
            return deleted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteByCollectionId(int collectionId) {
        String sql = "DELETE FROM collection_rule WHERE collection_id = :collectionId";

        try {
            jdbi.withHandle(h -> h.createUpdate(sql)
                    .bind("collectionId", collectionId)
                    .execute());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getProductsByRules(int collectionId, String ruleSetType) {
        List<CollectionRule> rules = findByCollectionId(collectionId);

        if (rules.isEmpty()) {
            return Collections.emptyList();
        }

        // Build WHERE clause từ rules
        StringBuilder whereClause = new StringBuilder();
        List<Object> params = new ArrayList<>();
        String connector = "AND".equalsIgnoreCase(ruleSetType) ? " AND " : " OR ";

        for (int i = 0; i < rules.size(); i++) {
            if (i > 0) {
                whereClause.append(connector);
            }
            whereClause.append(buildRuleCondition(rules.get(i), params, i));
        }

        String sql = String.format("""
                    SELECT * FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                      AND (%s)
                    ORDER BY added_at DESC
                """, whereClause.toString());

        try {
            return jdbi.withHandle(h -> {
                var query = h.createQuery(sql);
                // Bind tất cả params
                for (int i = 0; i < params.size(); i++) {
                    query.bind("param" + i, params.get(i));
                }
                return query.mapToBean(Product.class).list();
            });
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    /**
     * Lấy sản phẩm với phân trang
     */
    public List<Product> getProductsByRulesPaged(int collectionId, String ruleSetType, int limit, int offset) {
        List<CollectionRule> rules = findByCollectionId(collectionId);

        if (rules.isEmpty()) {
            return Collections.emptyList();
        }

        StringBuilder whereClause = new StringBuilder();
        List<Object> params = new ArrayList<>();
        String connector = "AND".equalsIgnoreCase(ruleSetType) ? " AND " : " OR ";

        for (int i = 0; i < rules.size(); i++) {
            if (i > 0) {
                whereClause.append(connector);
            }
            whereClause.append(buildRuleCondition(rules.get(i), params, i));
        }

        String sql = String.format("""
                    SELECT * FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                      AND (%s)
                    ORDER BY added_at DESC
                    LIMIT :limit OFFSET :offset
                """, whereClause.toString());

        try {
            return jdbi.withHandle(h -> {
                var query = h.createQuery(sql);
                for (int i = 0; i < params.size(); i++) {
                    query.bind("param" + i, params.get(i));
                }
                query.bind("limit", limit);
                query.bind("offset", offset);
                return query.mapToBean(Product.class).list();
            });
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }


    public int countProductsByRules(int collectionId, String ruleSetType) {
        List<CollectionRule> rules = findByCollectionId(collectionId);

        if (rules.isEmpty()) {
            return 0;
        }

        StringBuilder whereClause = new StringBuilder();
        List<Object> params = new ArrayList<>();
        String connector = "AND".equalsIgnoreCase(ruleSetType) ? " AND " : " OR ";

        for (int i = 0; i < rules.size(); i++) {
            if (i > 0) {
                whereClause.append(connector);
            }
            whereClause.append(buildRuleCondition(rules.get(i), params, i));
        }

        String sql = String.format("""
                    SELECT COUNT(*) FROM product
                    WHERE is_available = 1 AND is_discontinue = 0
                      AND (%s)
                """, whereClause.toString());

        try {
            return jdbi.withHandle(h -> {
                var query = h.createQuery(sql);
                for (int i = 0; i < params.size(); i++) {
                    query.bind("param" + i, params.get(i));
                }
                return query.mapTo(int.class).one();
            });
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private String buildRuleCondition(CollectionRule rule, List<Object> params, int paramIndex) {
        String field = rule.getFieldName();
        String operator = rule.getOperator();
        String value = rule.getValue();
        String paramName = ":param" + paramIndex;

        return switch (operator) {
            case OP_EQUALS -> {
                params.add(value);
                yield field + " = " + paramName;
            }
            case OP_NOT_EQUALS -> {
                params.add(value);
                yield field + " != " + paramName;
            }
            case OP_LESS_THAN -> {
                params.add(Double.parseDouble(value));
                yield field + " < " + paramName;
            }
            case OP_GREATER_THAN -> {
                params.add(Double.parseDouble(value));
                yield field + " > " + paramName;
            }
            case OP_LESS_EQUALS -> {
                params.add(Double.parseDouble(value));
                yield field + " <= " + paramName;
            }
            case OP_GREATER_EQUALS -> {
                params.add(Double.parseDouble(value));
                yield field + " >= " + paramName;
            }
            case OP_CONTAINS -> {
                params.add("%" + value + "%");
                yield field + " LIKE " + paramName;
            }
            case OP_STARTS_WITH -> {
                params.add(value + "%");
                yield field + " LIKE " + paramName;
            }
            case OP_ENDS_WITH -> {
                params.add("%" + value);
                yield field + " LIKE " + paramName;
            }
            default -> {
                params.add(value);
                yield field + " = " + paramName;
            }
        };
    }
}
