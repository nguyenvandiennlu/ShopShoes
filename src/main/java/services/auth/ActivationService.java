package services.auth;
import dao.auth.ActivationTokenDao;
import dao.user.UserDao;
import java.time.LocalDateTime;
import java.util.UUID;
public class ActivationService {
    private final ActivationTokenDao tokenDao = new ActivationTokenDao();
    private final UserDao userDao = new UserDao();

    public String createActivationToken(String email) {
        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(2);
        tokenDao.saveToken(email, token, expiresAt);
        return token;
    }
    public boolean activateUserByToken(String token) {
        String email = tokenDao.getEmailByToken(token);
        if (email == null) {
            return false;
        }
        userDao.activateByEmail(email);
        tokenDao.markTokenAsUsed(token);
        return true;
    }
    public boolean isTokenValid(String token) {
        String email = tokenDao.getEmailByToken(token);
        return email != null;
    }
}