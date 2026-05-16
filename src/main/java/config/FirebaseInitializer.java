package config;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.InputStream;

@WebListener
public class FirebaseInitializer implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                InputStream serviceAccount = sce.getServletContext()
                        .getResourceAsStream("/WEB-INF/firebase-service-account.json");

                if (serviceAccount == null) {
                    System.out.println("Firebase skipped: missing /WEB-INF/firebase-service-account.json");
                    return;
                }

                try (serviceAccount) {
                    FirebaseOptions options = FirebaseOptions.builder()
                            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                            .build();

                    FirebaseApp.initializeApp(options);
                    System.out.println("Firebase initialized!");
                }
            }
        } catch (Exception e) {
            System.out.println("Firebase skipped due to init error: " + e.getMessage());
        }
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
