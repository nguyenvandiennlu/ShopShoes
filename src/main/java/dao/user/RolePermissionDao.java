package dao.user;

import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RolePermissionDao {
    private final Jdbi jdbi;

    public RolePermissionDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public Map<String, Integer> getPermissionsForRole(String roleName) {
        if (roleName == null || roleName.isEmpty()) {
            return new HashMap<>();
        }

        String sql = "SELECT module_name, permission_value FROM role_permissions WHERE role_name = :roleName";
        try {
            return jdbi.withHandle(handle -> {
                List<Map<String, Object>> rows = handle.createQuery(sql)
                        .bind("roleName", roleName)
                        .mapToMap()
                        .list();

                Map<String, Integer> permMap = new HashMap<>();
                for (Map<String, Object> row : rows) {
                    String module = (String) row.get("module_name");
                    Number value = (Number) row.get("permission_value");
                    if (module != null && value != null) {
                        permMap.put(module.toLowerCase().trim(), value.intValue());
                    }
                }

                if ("ADMIN".equalsIgnoreCase(roleName)) {
                    permMap.putIfAbsent("dashboard", 1);
                    permMap.putIfAbsent("statistics", 1);
                    permMap.putIfAbsent("orders", 15);
                    permMap.putIfAbsent("products", 15);
                    permMap.putIfAbsent("promotions", 15);
                    permMap.putIfAbsent("users", 15);
                    permMap.putIfAbsent("settings", 0);
                } else if ("SUPER_ADMIN".equalsIgnoreCase(roleName)) {
                    permMap.putIfAbsent("dashboard", 1);
                    permMap.putIfAbsent("statistics", 1);
                    permMap.putIfAbsent("orders", 15);
                    permMap.putIfAbsent("products", 15);
                    permMap.putIfAbsent("promotions", 15);
                    permMap.putIfAbsent("users", 15);
                    permMap.putIfAbsent("settings", 15);
                }

                return permMap;
            });
        } catch (Exception e) {
            System.err.println("[RolePermissionDao] Lỗi lấy quyền cho role " + roleName + ": " + e.getMessage());
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    public boolean updateAllPermissions(String roleName, Map<String, Integer> permissions) {
        if (roleName == null || roleName.isEmpty() || permissions == null) {
            return false;
        }

        String sql = """
            INSERT INTO role_permissions (role_name, module_name, permission_value)
            VALUES (:roleName, :moduleName, :value)
            ON DUPLICATE KEY UPDATE permission_value = :value
        """;

        try {
            jdbi.useTransaction(handle -> {
                for (Map.Entry<String, Integer> entry : permissions.entrySet()) {
                    handle.createUpdate(sql)
                            .bind("roleName", roleName)
                            .bind("moduleName", entry.getKey().toLowerCase().trim())
                            .bind("value", entry.getValue())
                            .execute();
                }
            });
            return true;
        } catch (Exception e) {
            System.err.println("[RolePermissionDao] Lỗi cập nhật quyền cho role " + roleName + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasPermission(String roleName, String moduleName, int requiredAction) {
        if ("SUPER_ADMIN".equalsIgnoreCase(roleName)) {
            return true;
        }

        Map<String, Integer> perms = getPermissionsForRole(roleName);
        Integer userMask = perms.get(moduleName.toLowerCase().trim());
        if (userMask == null) {
            return false;
        }
        return (userMask & requiredAction) == requiredAction;
    }
}
