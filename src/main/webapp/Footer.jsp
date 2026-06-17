
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="footer">
    <div class="footer-top section">
        <div class="container">
            <div class="footer-brand">
                <a href="#" class="logo">
                    <img
                            src="${pageContext.request.contextPath}/assets/images/BHD%20LOGO.png"
                            width="110"
                            height="50"
                            alt="BHD"
                    />
                </a>

                <ul class="social-list">
                    <li>
                        <a
                                href="https://www.facebook.com/kcntt.nlu"
                                class="social-link"
                        >
                            <ion-icon name="logo-facebook"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.youtube.com/@NongLamUniversity/videos"
                                class="social-link"
                        >
                            <ion-icon name="logo-youtube"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.tiktok.com/@nonglam.university"
                                class="social-link"
                        >
                            <ion-icon name="logo-tiktok"></ion-icon>
                        </a>
                    </li>

                    <li>
                        <a
                                href="https://www.instagram.com/daihocnonglamtphcm.hcmuaf1955/"
                                class="social-link"
                        >
                            <ion-icon name="logo-instagram"></ion-icon>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="footer-link-box">
                <ul class="footer-list">
                    <li>
                        <p class="footer-list-title">Thông tin liên hệ</p>
                    </li>

                    <li>
                        <address class="footer-link">
                            <ion-icon name="location"></ion-icon>
                            <span class="footer-link-text">
                    Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh
                  </span>
                        </address>
                    </li>

                    <li>
                        <a href="#" class="footer-link">
                            <ion-icon name="call"></ion-icon>
                            <span class="footer-link-text">0332536387</span>
                        </a>
                    </li>

                    <li>
                        <a href="#" class="footer-link">
                            <ion-icon name="mail"></ion-icon>
                            <span class="footer-link-text">BHDsport@gmail.com</span>
                        </a>
                    </li>
                </ul>

                <ul class="footer-list">
                    <li><p class="footer-list-title">Tài khoản</p></li>
                    <li>
                        <a
                                href="${pageContext.request.contextPath}/account"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Tài khoản</span>
                        </a>
                    </li>
                    <li>
                        <a
                                href="${pageContext.request.contextPath}/cart"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>

                            <span class="footer-link-text">Xem giỏ hàng</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/wishlist"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>

                            <span class="footer-link-text">Yêu thích</span>
                        </a>
                    </li>
                </ul>

                <ul class="footer-list">
                    <li><p class="footer-list-title">Chính sách</p></li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/chinh-sach-bao-mat"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Chính sách bảo mật</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/chinh-sach-bao-hanh"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Chính sách bảo hành</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/huong-dan-mua-hang"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">Hướng dẫn mua hàng</span>
                        </a>
                    </li>

                    <li>
                        <a
                                href="${pageContext.request.contextPath}/faq"
                                class="footer-link"
                        >
                            <ion-icon name="chevron-forward-outline"></ion-icon>
                            <span class="footer-link-text">FAQs</span>
                        </a>
                    </li>
                </ul>


                <div class="footer-list">
                    <p class="footer-list-title">Đăng kí nhận tin</p>
                    <form
                            id="newsletter-form"
                            action=""
                            class="newsletter-form"
                            method="POST"
                    >
                        <input
                                type="email"
                                name="email"
                                required
                                placeholder="Email"
                                class="newsletter-input"
                        />
                        <button type="submit" class="btn btn-primary">
                            <span>Đăng Kí</span>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="container">
            <p class="copyright">
                &copy; 2025
                <a href="#" class="copyright-link">BHD-SPORT SHOES</a>. Cùng bạn
                chinh phục mọi hành trình
            </p>
        </div>
    </div>
</footer>