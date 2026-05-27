/**
 * Search Autocomplete Script
 * Xử lý hiển thị suggestions khi người dùng gõ từ khóa tìm kiếm
 */

document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("search-input");
    const suggestionsContainer = document.getElementById("search-suggestions");
    const suggestionsList = document.getElementById("suggestions-list");
    const suggestionsFooter = document.getElementById("suggestions-footer");
    const viewAllLink = document.getElementById("view-all-link");
    const searchForm = document.getElementById("search-form");
    const searchCloseBtn = document.getElementById("searchCloseBtn");

    let debounceTimer;
    let currentKeyword = "";

    // Xử lý input change
    if (searchInput) {
        searchInput.addEventListener("input", function (e) {
            clearTimeout(debounceTimer);
            const keyword = e.target.value.trim();

            if (keyword.length === 0) {
                hideSuggestions();
                return;
            }

            // Debounce AJAX call
            debounceTimer = setTimeout(() => {
                fetchSuggestions(keyword);
            }, 300);
        });

        // Đóng suggestions khi click ra ngoài
        document.addEventListener("click", function (e) {
            if (!suggestionsContainer.contains(e.target) && !searchInput.contains(e.target)) {
                hideSuggestions();
            }
        });

        // Mở suggestions lại khi focus
        searchInput.addEventListener("focus", function () {
            if (this.value.trim().length > 0) {
                showSuggestions();
            }
        });

        // Xử lý submit form khi nhấn Enter
        searchForm.addEventListener("submit", function (e) {
            e.preventDefault();
            const keyword = searchInput.value.trim();
            if (keyword) {
                // Redirect to products page with search query
                window.location.href = `${CONTEXT_PATH}/products?q=${encodeURIComponent(keyword)}`;
            }
        });
    }

    // Close button
    if (searchCloseBtn) {
        searchCloseBtn.addEventListener("click", function (e) {
            e.preventDefault();
            searchInput.value = "";
            hideSuggestions();
        });
    }

    /**
     * Fetch suggestions từ server
     */
    function fetchSuggestions(keyword) {
        currentKeyword = keyword;

        fetch(`${CONTEXT_PATH}/search-ajax?q=${encodeURIComponent(keyword)}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();
            })
            .then(data => {
                renderSuggestions(data, keyword);
            })
            .catch(error => {
                console.error("Error fetching suggestions:", error);
                showErrorMessage();
            });
    }

    /**
     * Render suggestions vào DOM
     */
    function renderSuggestions(data, keyword) {
        suggestionsList.innerHTML = "";

        const suggestions = data.suggestions || [];
        const totalResults = data.totalResults || 0;

        if (suggestions.length === 0) {
            showNoResults(keyword);
            return;
        }

        // Thêm từng suggestion vào list
        suggestions.forEach((product, index) => {
            const li = createSuggestionItem(product, index);
            suggestionsList.appendChild(li);
        });

        // Update footer với số kết quả
        updateFooter(keyword, totalResults, suggestions.length);

        showSuggestions();
    }

    /**
     * Tạo HTML element cho một suggestion item
     */
    function createSuggestionItem(product, index) {
        const li = document.createElement("li");
        li.className = "suggestion-item";

        // Scroll arrow (hiện nếu không phải item cuối)
        const scrollArrow = index === 4 ? "" : "";

        const html = `
            <a href="${CONTEXT_PATH}/product?id=${product.id}" class="suggestion-link">
                <div class="suggestion-image">
                    <img src="${product.mainImageUrl || CONTEXT_PATH + '/assets/images/placeholder.jpg'}" 
                         alt="${product.name}" />
                </div>
                <div class="suggestion-info">
                    <div class="suggestion-name">${escapeHtml(product.name)}</div>
                    <div class="suggestion-price">
                        <span class="final-price">${product.finalPrice}</span>
                        ${product.price !== product.finalPrice ? `<span class="original-price">${product.price}</span>` : ""}
                    </div>
                </div>
            </a>
        `;

        li.innerHTML = html;

        // Hover effect
        li.addEventListener("mouseenter", function () {
            document.querySelectorAll(".suggestion-item").forEach(item => {
                item.classList.remove("hover");
            });
            li.classList.add("hover");
        });

        // Click to product detail
        li.addEventListener("click", function (e) {
            if (e.target.closest(".suggestion-link")) {
                // Default behavior - navigate to product
            }
        });

        return li;
    }

    /**
     * Update footer với "Xem tất cả X sản phẩm"
     */
    function updateFooter(keyword, totalResults, suggestionsCount) {
        if (viewAllLink && suggestionsFooter) {
            let displayCount = totalResults > suggestionsCount ? totalResults : suggestionsCount;
            viewAllLink.href = `${CONTEXT_PATH}/products?q=${encodeURIComponent(keyword)}`;
            viewAllLink.innerHTML = `Xem tất cả ${displayCount} sản phẩm`;
            suggestionsFooter.style.display = "block";
            viewAllLink.style.display = "block";
        }
    }

    /**
     * Hiển thị thông báo khi không có kết quả
     */
    function showNoResults(keyword) {
        suggestionsList.innerHTML = `
            <li class="suggestion-item no-results">
                <div class="no-results-message">
                    Không tìm thấy sản phẩm nào cho "<strong>${escapeHtml(keyword)}</strong>"
                </div>
            </li>
        `;

        // Hide footer
        if (suggestionsFooter) {
            suggestionsFooter.style.display = "none";
        }

        showSuggestions();
    }

    /**
     * Hiển thị thông báo lỗi
     */
    function showErrorMessage() {
        suggestionsList.innerHTML = `
            <li class="suggestion-item error">
                <div class="error-message">Có lỗi xảy ra khi tìm kiếm</div>
            </li>
        `;

        if (suggestionsFooter) {
            suggestionsFooter.style.display = "none";
        }

        showSuggestions();
    }

    /**
     * Show suggestions container
     */
    function showSuggestions() {
        if (suggestionsContainer) {
            suggestionsContainer.classList.add("active");
        }
    }

    /**
     * Hide suggestions container
     */
    function hideSuggestions() {
        if (suggestionsContainer) {
            suggestionsContainer.classList.remove("active");
        }
    }

    /**
     * Escape HTML để tránh XSS
     */
    function escapeHtml(text) {
        const map = {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#039;"
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }
});
