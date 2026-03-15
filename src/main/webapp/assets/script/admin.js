// document.addEventListener("DOMContentLoaded", () => {
//     const menuItems = document.querySelectorAll(".sidebar .menu li");
//     const container = document.getElementById("content-container");
//
//     let currentPage = localStorage.getItem("currentPage") || "admin-dashboard.jsp";
//
//     // Hàm load page
//     function loadPage(page) {
//         fetch(page)
//             .then(res => res.text())
//             .then(html => {
//                 container.innerHTML = html;
//                 window.scrollTo(0, 0);
//
//                 // Cập nhật active menu
//                 menuItems.forEach(item => {
//                     if (item.getAttribute("data-page") === page) {
//                         item.classList.add("active");
//                     } else {
//                         item.classList.remove("active");
//                     }
//                 });
//
//                 // Lưu page hiện tại vào localStorage
//                 localStorage.setItem("currentPage", page);
//             })
//             .catch(e => {
//                 container.innerHTML = "<p style ='color; red;text-align:center;'>Khong the tai trang. Vui long thu lai.</p>";
//                 console.error(e)
//             });
//     }
//
//     // Gán sự kiện click cho menu
//     menuItems.forEach(item => {
//         item.addEventListener("click", (e) => {
//             e.preventDefault();
//             const page = item.getAttribute("data-page");
//             if (page && page !== "admin-logout.jsp") {
//                 loadPage(page);
//             } else if (page === "admin-logout.jsp") {
//                 window.location.href = "admin-logout.jsp"; // logout
//             }
//         });
//     });
//
//     // Load page đầu tiên khi trang reload
//     loadPage(currentPage);
// });
//
// const links = document.querySelectorAll('.menu li a');
// const container = document.getElementById('content-container');
// links.forEach(link => {
//     link.addEventListener('click', function (e){
//         e.preventDefault();
//         links.forEach(l => l.parentElement.classList.remove('active'));
//         this.parentElement.classList.add('active');
//
//         fetch(this.href)
//             .then(resizeBy => resizeBy.text())
//             .then(html => container.innerHTML = html)
//             .catch(err => console.error(err));
//     });
// });