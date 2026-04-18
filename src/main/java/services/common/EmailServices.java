package services.common;
import JavaMail.IJavaMail;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import utils.EmailConfigLoader;
import java.util.Properties;
public class EmailServices implements IJavaMail {
    @Override
    public boolean send(String to, String subject, String messageContent) {
        try {
            String mailHost = EmailConfigLoader.get("mail.host");
            String mailPort = EmailConfigLoader.get("mail.port");
            String mailAuth = EmailConfigLoader.get("mail.auth");
            String mailStarttls = EmailConfigLoader.get("mail.starttls");
            String mailUsername = EmailConfigLoader.get("mail.username");
            String mailPassword = EmailConfigLoader.get("mail.password");
            
            if (mailHost == null || mailPort == null || mailUsername == null || mailPassword == null) {
                System.err.println("[ERROR] Email configuration is incomplete!");
                System.err.println("[DEBUG] mail.host: " + mailHost);
                System.err.println("[DEBUG] mail.port: " + mailPort);
                System.err.println("[DEBUG] mail.username: " + mailUsername);
                System.err.println("[DEBUG] mail.password: " + (mailPassword != null ? "***" : "null"));
                System.err.println("[DEBUG] mail.auth: " + mailAuth);
                System.err.println("[DEBUG] mail.starttls: " + mailStarttls);
                return false;
            }
            
            if (mailAuth == null) mailAuth = "true";
            if (mailStarttls == null) mailStarttls = "true";
            
            Properties props = new Properties();
            props.put("mail.smtp.host", mailHost);
            props.put("mail.smtp.port", mailPort);
            props.put("mail.smtp.auth", mailAuth);
            props.put("mail.smtp.starttls.enable", mailStarttls);
            props.put("mail.smtp.ssl.trust", mailHost);
            
            System.out.println("[DEBUG] Email config loaded: host=" + mailHost + ", port=" + mailPort + ", auth=" + mailAuth + ", starttls=" + mailStarttls);
            
            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(mailUsername, mailPassword);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(mailUsername));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");
            message.setContent(messageContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[DEBUG] Email sent successfully to: " + to);
            return true;
        } catch (MessagingException e) {
            System.err.println("[ERROR] MessagingException when sending email to " + to + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("[ERROR] Unexpected error in EmailServices.send(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}