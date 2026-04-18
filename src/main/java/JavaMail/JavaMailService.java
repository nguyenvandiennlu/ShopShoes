package JavaMail;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import utils.EmailConfigLoader;

import java.util.Properties;

public class JavaMailService implements IJavaMail {

    @Override
    public boolean send(String to, String subject, String messageContent) {
        Properties props = new Properties();

        props.put("mail.smtp.host", EmailConfigLoader.get("mail.host"));
        props.put("mail.smtp.port", EmailConfigLoader.get("mail.port"));
        props.put("mail.smtp.auth", EmailConfigLoader.get("mail.auth"));
        props.put("mail.smtp.starttls.enable", EmailConfigLoader.get("mail.starttls.enable"));
        props.put("mail.smtp.ssl.trust", EmailConfigLoader.get("mail.smtp.ssl.trust"));
        props.put("mail.smtp.starttls.required", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        EmailConfigLoader.get("mail.username"),
                        EmailConfigLoader.get("mail.password")
                );
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EmailConfigLoader.get("mail.username")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");
            message.setContent(messageContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}