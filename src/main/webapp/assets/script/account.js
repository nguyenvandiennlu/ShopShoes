document.addEventListener("DOMContentLoaded", function() {
    // Lấy các phần tử
    const logoutBtn = document.getElementById("btn-logout-trigger");
    const logoutModal = document.getElementById("logoutModal");
    const closeSpan = document.getElementById("closeLogout");
    const cancelBtn = document.getElementById("cancelLogout");

    // Hàm mở Modal
    if (logoutBtn) {
        logoutBtn.addEventListener("click", function(e) {
            e.preventDefault(); // Ngăn chuyển trang
            logoutModal.style.display = "block"; // Hiện popup
        });
    }

    // Hàm đóng Modal
    function closeModal() {
        logoutModal.style.display = "none";
    }

    // Gán sự kiện đóng
    if (closeSpan) closeSpan.addEventListener("click", closeModal);
    if (cancelBtn) cancelBtn.addEventListener("click", closeModal);

    // Bấm ra ngoài vùng trắng cũng đóng modal
    window.addEventListener("click", function(e) {
        if (e.target == logoutModal) {
            closeModal();
        }
    });
});