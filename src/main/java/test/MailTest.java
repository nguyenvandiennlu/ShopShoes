package test;

import JavaMail.IJavaMail;
import JavaMail.JavaMailService;

public class MailTest {
    public static void main(String[] args) {

        IJavaMail mail = new JavaMailService();

        boolean ok = mail.send(
                "diennguyen17102005@gmail.com",
                "Test gửi mail",
                "<h2>Test thành công</h2><p>Nếu thấy mail này là OK</p>"
        );

        System.out.println("Kết quả gửi: " + ok);
    }
}