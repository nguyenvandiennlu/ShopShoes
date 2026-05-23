'use strict';

document.addEventListener('DOMContentLoaded', function () {
    const filterForm = document.getElementById('filter-form');
    const productsContainer = document.getElementById('productsContainer');
    const slider1 = document.getElementById('slider-1');
    const slider2 = document.getElementById('slider-2');
    const range1 = document.getElementById('range1');
    const range2 = document.getElementById('range2');
    const minPriceInput = document.getElementById('minPriceInput');
    const maxPriceInput = document.getElementById('maxPriceInput');
    const priceMinBoundInput = document.getElementById('priceMinBoundInput');
    const priceMaxBoundInput = document.getElementById('priceMaxBoundInput');
    const sliderTrack = document.querySelector('.slider-track');
    const sortSelect = document.getElementById('sort-select');

    const minGap = 100000;

    function toInt(value, fallback) {
        const n = parseInt(value, 10);
        return Number.isFinite(n) ? n : fallback;
    }

    function formatVND(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + 'đ';
    }

    function getBounds() {
        const min = toInt(slider1?.min, 0);
        const max = toInt(slider1?.max, 0);
        return { min, max: Math.max(min, max) };
    }

    function fillColor() {
        if (!slider1 || !slider2 || !sliderTrack) return;

        const bounds = getBounds();
        const range = Math.max(bounds.max - bounds.min, 1);
        const percent1 = ((toInt(slider1.value, bounds.min) - bounds.min) / range) * 100;
        const percent2 = ((toInt(slider2.value, bounds.max) - bounds.min) / range) * 100;

        sliderTrack.style.background = `linear-gradient(to right, #ddd ${percent1}%, #d90429 ${percent1}%, #d90429 ${percent2}%, #ddd ${percent2}%)`;
    }

    function clampSliderValues() {
        if (!slider1 || !slider2) return;
        const bounds = getBounds();

        let v1 = toInt(slider1.value, bounds.min);
        let v2 = toInt(slider2.value, bounds.max);

        v1 = Math.max(bounds.min, Math.min(v1, bounds.max));
        v2 = Math.max(bounds.min, Math.min(v2, bounds.max));

        if (v2 - v1 < minGap) {
            if (v1 + minGap <= bounds.max) {
                v2 = v1 + minGap;
            } else if (v2 - minGap >= bounds.min) {
                v1 = v2 - minGap;
            } else {
                v1 = bounds.min;
                v2 = bounds.max;
            }
        }

        slider1.value = v1;
        slider2.value = v2;

        if (range1) range1.value = formatVND(v1);
        if (range2) range2.value = formatVND(v2);
        if (minPriceInput) minPriceInput.value = v1;
        if (maxPriceInput) maxPriceInput.value = v2;

        fillColor();
    }

    function applyBounds(minBound, maxBound, keepCurrentSelection) {
        if (!slider1 || !slider2) return;

        let min = toInt(minBound, 0);
        let max = toInt(maxBound, 0);
        if (max < min) {
            min = 0;
            max = 0;
        }

        const prev1 = toInt(slider1.value, min);
        const prev2 = toInt(slider2.value, max);

        slider1.min = String(min);
        slider1.max = String(max);
        slider2.min = String(min);
        slider2.max = String(max);

        if (priceMinBoundInput) priceMinBoundInput.value = min;
        if (priceMaxBoundInput) priceMaxBoundInput.value = max;

        if (keepCurrentSelection) {
            slider1.value = prev1;
            slider2.value = prev2;
        } else {
            slider1.value = min;
            slider2.value = max;
        }

        clampSliderValues();
    }

    window.slideOne = function () {
        clampSliderValues();
    };

    window.slideTwo = function () {
        clampSliderValues();
    };

    window.updatePriceBoundsFromHtml = function (html, keepCurrentSelection = true) {
        const wrapper = document.createElement('div');
        wrapper.innerHTML = html;

        const minMeta = wrapper.querySelector('#priceMinBoundMeta');
        const maxMeta = wrapper.querySelector('#priceMaxBoundMeta');

        if (!minMeta || !maxMeta) return;
        applyBounds(minMeta.value, maxMeta.value, keepCurrentSelection);
    };

    function loadFilteredProducts() {
        if (!filterForm || !productsContainer) return;

        const formData = new FormData(filterForm);
        formData.append('ajax', '1');

        if (sortSelect) {
            formData.append('sort', sortSelect.value);
        }

        const params = new URLSearchParams(formData);
        const url = filterForm.action + '?' + params.toString();

        productsContainer.style.opacity = '0.5';

        fetch(url)
            .then(response => response.text())
            .then(html => {
                if (window.updatePriceBoundsFromHtml) {
                    window.updatePriceBoundsFromHtml(html, true);
                }

                productsContainer.innerHTML = html;
                productsContainer.style.opacity = '1';

                const newUrl = CONTEXT_PATH + '/products?' + params.toString().replace('&ajax=1', '');
                window.history.pushState({}, '', newUrl);
            })
            .catch(error => {
                console.error('Error loading products:', error);
                productsContainer.style.opacity = '1';
            });
    }

    if (slider1 && slider2) {
        const initialMin = toInt(priceMinBoundInput?.value, toInt(slider1.min, 0));
        const initialMax = toInt(priceMaxBoundInput?.value, toInt(slider1.max, 0));
        applyBounds(initialMin, initialMax, true);
    }

    if (sortSelect) {
        sortSelect.addEventListener('change', function () {
            loadFilteredProducts();
        });
    }

    if (filterForm) {
        filterForm.addEventListener('submit', function (e) {
            e.preventDefault();
            loadFilteredProducts();
        });

        const checkboxes = filterForm.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                loadFilteredProducts();
            });
        });

        let sliderTimeout;
        if (slider1) {
            slider1.addEventListener('change', function () {
                clearTimeout(sliderTimeout);
                sliderTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }
        if (slider2) {
            slider2.addEventListener('change', function () {
                clearTimeout(sliderTimeout);
                sliderTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }

        const searchInput = document.getElementById('filter-search-input');
        let searchTimeout;
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(loadFilteredProducts, 500);
            });
        }
    }

    const clearAllBtn = document.getElementById('clear-all-btn');
    if (clearAllBtn) {
        clearAllBtn.addEventListener('click', function () {
            const checkboxes = filterForm.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(cb => cb.checked = false);

            const searchInput = document.getElementById('filter-search-input');
            if (searchInput) searchInput.value = '';

            if (sortSelect) sortSelect.value = 'default';

            const minBound = toInt(priceMinBoundInput?.value, toInt(slider1?.min, 0));
            const maxBound = toInt(priceMaxBoundInput?.value, toInt(slider1?.max, 0));
            applyBounds(minBound, maxBound, false);

            loadFilteredProducts();
        });
    }

    const toggleBtns = document.querySelectorAll('.toggle-btn');
    toggleBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const filterGroup = this.closest('.filter-group');
            if (filterGroup) {
                filterGroup.classList.toggle('collapsed');
                this.textContent = filterGroup.classList.contains('collapsed') ? '+' : '-';
            }
        });
    });
});
