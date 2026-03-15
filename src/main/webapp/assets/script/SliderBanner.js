
    // Khởi tạo Swiper
    const swiper = new Swiper(".swiper-container", {
    // Các tùy chọn cơ bản:
    loop: true, // Lặp vô hạn

    // Phân trang (dấu chấm)
    pagination: {
    el: ".swiper-pagination",
    clickable: true,
},

    // Nút điều hướng (Nút qua lại)
    navigation: {
    nextEl: ".swiper-button-next",
    prevEl: ".swiper-button-prev",
},

    // Tự động chạy (nếu muốn)
    autoplay: {
    delay: 5000,
    disableOnInteraction: false,
},
});
