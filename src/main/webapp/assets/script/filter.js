'use strict';

/**
 * Script xử lý bộ lọc sản phẩm với AJAX (không reload trang)
 */
document.addEventListener("DOMContentLoaded", function () {

    // Các element
    const filterForm = document.getElementById("filter-form");
    const productsContainer = document.getElementById("productsContainer");
    const slider1 = document.getElementById("slider-1");
    const slider2 = document.getElementById("slider-2");
    const range1 = document.getElementById("range1");
    const range2 = document.getElementById("range2");
    const minPriceInput = document.getElementById("minPriceInput");
    const maxPriceInput = document.getElementById("maxPriceInput");
    const sliderTrack = document.querySelector(".slider-track");

    const minGap = 100000;
    const sliderMaxValue = 10000000;

    // Format số thành tiền tệ VND
    function formatVND(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + "đ";
    }

    // Cập nhật màu track slider
    function fillColor() {
        if (!slider1 || !slider2 || !sliderTrack) return;

        const percent1 = (slider1.value / sliderMaxValue) * 100;
        const percent2 = (slider2.value / sliderMaxValue) * 100;
        sliderTrack.style.background = `linear-gradient(to right, #ddd ${percent1}%, #d90429 ${percent1}%, #d90429 ${percent2}%, #ddd ${percent2}%)`;
    }

    // Xử lý kéo slider 1 (min price)
    window.slideOne = function () {
        if (!slider1 || !slider2) return;

        if (parseInt(slider2.value) - parseInt(slider1.value) <= minGap) {
            slider1.value = parseInt(slider2.value) - minGap;
        }
        if (range1) range1.value = formatVND(parseInt(slider1.value));
        if (minPriceInput) minPriceInput.value = slider1.value;
        fillColor();
    };

    // Xử lý kéo slider 2 (max price)
    window.slideTwo = function () {
        if (!slider1 || !slider2) return;

        if (parseInt(slider2.value) - parseInt(slider1.value) <= minGap) {
            slider2.value = parseInt(slider1.value) + minGap;
        }
        if (range2) range2.value = formatVND(parseInt(slider2.value));
        if (maxPriceInput) maxPriceInput.value = slider2.value;
        fillColor();
    };

    // Khởi tạo giá trị ban đầu
    if (slider1 && slider2) {
        slideOne();
        slideTwo();
        fillColor();
    }

    // ======= AJAX FILTER =======
    const sortSelect = document.getElementById("sort-select");

    function loadFilteredProducts() {
        if (!filterForm || !productsContainer) return;

        // Lấy tất cả dữ liệu từ form
        const formData = new FormData(filterForm);
        formData.append("ajax", "1"); // Để Controller trả về fragment

        // Thêm sort từ dropdown (nằm ngoài form)
        if (sortSelect) {
            formData.append("sort", sortSelect.value);
        }

        // Tạo URL với query params
        const params = new URLSearchParams(formData);
        const url = filterForm.action + "?" + params.toString();

        // Hiển thị loading
        productsContainer.style.opacity = "0.5";

        fetch(url)
            .then(response => response.text())
            .then(html => {
                productsContainer.innerHTML = html;
                productsContainer.style.opacity = "1";

                // Cập nhật URL để có thể bookmark/share
                const newUrl = CONTEXT_PATH + "/products?" + params.toString().replace("&ajax=1", "");
                window.history.pushState({}, '', newUrl);
            })
            .catch(error => {
                console.error("Error loading products:", error);
                productsContainer.style.opacity = "1";
            });
    }

    // Sự kiện cho sort dropdown
    if (sortSelect) {
        sortSelect.addEventListener("change", function () {
            loadFilteredProducts();
        });
    }

    // Gắn sự kiện submit form bằng AJAX
    if (filterForm) {
        filterForm.addEventListener("submit", function (e) {
            e.preventDefault();
            loadFilteredProducts();
        });

        // Tự động filter khi thay đổi checkbox (không cần nhấn nút)
        const checkboxes = filterForm.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener("change", function () {
                loadFilteredProducts();
            });
        });

        // Tự động filter khi thả slider sau 500ms
        let sliderTimeout;
        if (slider1) {
            slider1.addEventListener("change", function () {
                clearTimeout(sliderTimeout);
                sliderTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }
        if (slider2) {
            slider2.addEventListener("change", function () {
                clearTimeout(sliderTimeout);
                sliderTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }

        // Tự động filter khi nhập xong search (sau 500ms)
        const searchInput = document.getElementById("filter-search-input");
        let searchTimeout;
        if (searchInput) {
            searchInput.addEventListener("input", function () {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }
    }

    // Xử lý nút XÓA TẤT CẢ
    const clearAllBtn = document.getElementById("clear-all-btn");
    if (clearAllBtn) {
        clearAllBtn.addEventListener("click", function () {
            // Reset tất cả checkbox
            const checkboxes = filterForm.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(cb => cb.checked = false);

            // Reset slider
            if (slider1) slider1.value = 0;
            if (slider2) slider2.value = sliderMaxValue;
            slideOne();
            slideTwo();

            // Reset search
            const searchInput = document.getElementById("filter-search-input");
            if (searchInput) searchInput.value = "";

            // Reload products
            loadFilteredProducts();
        });
    }

    // Xử lý toggle filter groups
    const toggleBtns = document.querySelectorAll(".toggle-btn");
    toggleBtns.forEach(function (btn) {
        btn.addEventListener("click", function () {
            const filterGroup = this.closest(".filter-group");
            if (filterGroup) {
                filterGroup.classList.toggle("collapsed");
                this.textContent = filterGroup.classList.contains("collapsed") ? "+" : "-";
            }
        });
    });

});