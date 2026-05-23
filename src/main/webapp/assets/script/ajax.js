document.addEventListener("click", function (e) {
    // Tìm nút phân trang (hỗ trợ cả click vào icon bên trong nút)
    const btn = e.target.closest(".page-btn");

    // Kiểm tra tính hợp lệ
    if (btn && !btn.classList.contains("disabled") && !btn.classList.contains("active")) {

        const page = parseInt(btn.dataset.page, 10);
        if (!Number.isFinite(page) || page < 1) return;
        const filterForm = document.getElementById("filter-form");
        const sortSelect = document.getElementById("sort-select");

        let queryString = "";
        if (filterForm) {
            const formData = new FormData(filterForm);

            if (sortSelect) {
                formData.append("sort", sortSelect.value);
            }
            formData.append("page", page);
            formData.append("ajax", "1");

            const params = new URLSearchParams(formData);
            queryString = "?" + params.toString();
        } else {
            queryString = `?page=${page}&ajax=1`;
        }

        // --- Giai đoạn 2: Gọi Server ---
        const productsContainer = document.getElementById("productsContainer");
        if (productsContainer) productsContainer.style.opacity = "0.5";

        fetch(`${CONTEXT_PATH}/products${queryString}`)
            .then(res => res.text())
            .then(html => {
                if (window.updatePriceBoundsFromHtml) {
                    window.updatePriceBoundsFromHtml(html, true);
                }
                if (productsContainer) {
                    productsContainer.innerHTML = html;
                    productsContainer.style.opacity = "1";

                    // Cuộn lên đầu danh sách
                    productsContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });

                    // Cập nhật URL trình duyệt (để F5 không mất trang)
                    const newUrl = CONTEXT_PATH + "/products" + queryString.replace("&ajax=1", "");
                    window.history.pushState({}, '', newUrl);
                }
            })
            .catch(err => {
                console.error(err);
                if (productsContainer) productsContainer.style.opacity = "1";
            });
    }
});
