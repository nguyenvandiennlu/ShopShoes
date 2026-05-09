package services.auth;

import dao.auth.TokenTypeDao;
import dao.user.UserDao;
import java.time.LocalDateTime;
import java.util.UUID;
import enums.TokenType;

public class TokenTypeService {
    private final TokenTypeDao tokenDao = new TokenTypeDao();
    private final UserDao userDao = new UserDao();
    public String createActivationToken(String email) {
        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(2);
        tokenDao.saveToken(email, token, TokenType.ACCOUNT_ACTIVATION, expiresAt);
        return token;
    }
    public boolean activateUserByToken(String token) {
        String email = tokenDao.getEmailByToken(token, TokenType.ACCOUNT_ACTIVATION);
        if (email == null) {
            return false;
        }
        userDao.activateByEmail(email);
        tokenDao.markTokenAsUsed(token);
        return true;
    }

    public boolean verifyEmailByToken(String token) {
        String email = tokenDao.getEmailByToken(token, TokenType.ACCOUNT_ACTIVATION);
        if (email == null) {
            return false;
        }
        userDao.verifyEmailByEmail(email);
        tokenDao.markTokenAsUsed(token);
        return true;
    }

    public String getEmailByToken(String token) {
        return tokenDao.getEmailByToken(token, TokenType.ACCOUNT_ACTIVATION);
    }
    
    }