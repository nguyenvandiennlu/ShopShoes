package dao;
import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;
import utils.Config;
import java.sql.SQLException;
public class JDBIConnector {
    private static Jdbi jdbi;
    public static Jdbi getJdbi() {
        if (jdbi == null) {
            connect();
        }
        return jdbi;
    }
    private static void connect() {
        try {
            MysqlDataSource dataSource = new MysqlDataSource();
            String host = Config.get("db.host", "127.0.0.1");
            int port = Config.getInt("db.port", 3306);
            String dbName = Config.get("db.name", "shopshoes");
            String user = Config.get("db.username", "root");
            String pass = Config.get("db.pass", "root");
            String url = String.format(
                "jdbc:mysql://%s:%d/%s?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&forceConnectionTimeZoneToSession=true&characterEncoding=UTF-8",
                host, port, dbName
            );
            dataSource.setUrl(url);
            dataSource.setUser(user);
            dataSource.setPassword(pass);
            dataSource.setAutoReconnect(true);
            dataSource.setUseCompression(true);
            jdbi = Jdbi.create(dataSource);
            System.out.println("DB Connected: " + host + ":" + port + "/" + dbName);
        } catch (SQLException e) {
            System.out.println("DB Error: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
    public static void main(String[] args) {
        try {
            Jdbi db = getJdbi();
            int count = db.withHandle(h -> 
                h.createQuery("SELECT COUNT(*) FROM users")
                 .mapTo(int.class)
                 .one()
            );
            System.out.println("Users: " + count);
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
