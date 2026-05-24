'use strict';

/**
 * Script chạy khi trang web tải xong
 */
document.addEventListener("DOMContentLoaded", function () {

    /* ==================================================
       1. XỬ LÝ MENU MOBILE (HEADER)
    ================================================== */
    const navOpenBtn = document.querySelector(".nav-open-btn");
    const navCloseBtn = document.querySelector(".nav-close-btn");
    const navbar = document.querySelector(".navbar");
    const overlay = document.querySelector(".overlay");

    const toggleNavbar = function () {
        if (navbar) navbar.classList.toggle("active");
        if (overlay) overlay.classList.toggle("active");
    };

    if (navOpenBtn) navOpenBtn.addEventListener("click", toggleNavbar);
    if (navCloseBtn) navCloseBtn.addEventListener("click", toggleNavbar);
    if (overlay) overlay.addEventListener("click", toggleNavbar);
    /* ==================================================
       2. XỬ LÝ TOGGLE SEARCH FORM
    ================================================== */
    const searchToggleBtn = document.getElementById("searchToggleBtn");
    const searchToggleBtnMobile = document.getElementById("searchToggleBtnMobile");
    const searchCloseBtn = document.getElementById("searchCloseBtn");
    const searchForm = document.getElementById("search-form");
    const searchWrapper = document.querySelector(".search-wrapper");

    // Desktop search button
    if (searchToggleBtn && searchWrapper) {
        searchToggleBtn.addEventListener("click", function () {
            searchWrapper.classList.toggle("active");
            const searchInput = searchWrapper.querySelector("input");
            if (searchInput && searchWrapper.classList.contains("active")) {
                searchInput.focus();
            }
        });
    }

    // Mobile search button
    if (searchToggleBtnMobile && searchWrapper) {
        searchToggleBtnMobile.addEventListener("click", function () {
            searchWrapper.classList.toggle("active");
            const searchInput = searchWrapper.querySelector("input");
            if (searchInput && searchWrapper.classList.contains("active")) {
                searchInput.focus();
            }
        });
    }

    // Close button
    if (searchCloseBtn && searchWrapper) {
        searchCloseBtn.addEventListener("click", function () {
            searchWrapper.classList.remove("active");
        });
    }

    /* ==================================================
       3. ĐỒNG BỘ Ô TÌM KIẾM HEADER VÀ FILTER
    ================================================== */
    const headerSearchInput = searchForm ? searchForm.querySelector("input[name='q']") : null;
    const filterSearchInput = document.getElementById("filter-search-input");

    // Đồng bộ: khi nhập ở header -> cập nhật filter
    if (headerSearchInput && filterSearchInput) {
        headerSearchInput.addEventListener("input", function () {
            filterSearchInput.value = this.value;
        });

        // Đồng bộ: khi nhập ở filter -> cập nhật header
        filterSearchInput.addEventListener("input", function () {
            headerSearchInput.value = this.value;
        });
    }
});