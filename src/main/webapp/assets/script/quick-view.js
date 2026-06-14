/**
 * Quick View Modal for Product Cards
 * - Fetches product data via AJAX
 * - Displays in a beautiful modal
 * - Allows adding to cart directly
 * - Responsive and accessible
 */
(function () {
  'use strict';

  let activeOverlay = null;
  let isLoading = false;

  // ---- Create overlay structure ----
  function getOverlay() {
    let overlay = document.querySelector('.quick-view-overlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.className = 'quick-view-overlay';
      overlay.innerHTML = `
        <div class="quick-view-modal" role="dialog" aria-modal="true" aria-label="Quick view">
          <button class="quick-view-close" aria-label="Close">&times;</button>
          <div class="quick-view-loading" style="display:none;">
            <div class="spinner"></div>
          </div>
          <div class="quick-view-image"></div>
          <div class="quick-view-info"></div>
        </div>
      `;
      document.body.appendChild(overlay);

      // Close on overlay click
      overlay.addEventListener('click', function (e) {
        if (e.target === overlay) {
          closeQuickView();
        }
      });

      // Close on close button
      overlay.querySelector('.quick-view-close').addEventListener('click', closeQuickView);

      // Close on Escape
      overlay.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeQuickView();
      });
    }
    return overlay;
  }

  function showLoading(overlay) {
    const modal = overlay.querySelector('.quick-view-modal');
    modal.querySelector('.quick-view-loading').style.display = 'flex';
    modal.querySelector('.quick-view-image').style.display = 'none';
    modal.querySelector('.quick-view-info').style.display = 'none';
  }

  function hideLoading(overlay) {
    const modal = overlay.querySelector('.quick-view-modal');
    modal.querySelector('.quick-view-loading').style.display = 'none';
    modal.querySelector('.quick-view-image').style.display = 'flex';
    modal.querySelector('.quick-view-info').style.display = 'flex';
  }

  function closeQuickView() {
    const overlay = document.querySelector('.quick-view-overlay');
    if (overlay) {
      overlay.classList.remove('active');
      document.body.style.overflow = '';
      activeOverlay = null;
    }
  }

  function openQuickView(productId, contextPath) {
    if (isLoading) return;
    isLoading = true;

    const overlay = getOverlay();
    activeOverlay = overlay;
    showLoading(overlay);

    // Fetch product data
    const url = `${contextPath || window.CONTEXT_PATH || ''}/product/quick-view?id=${productId}`;
    
    // First try a dedicated endpoint, fallback to product page
    fetch(url, {
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })
    .then(res => {
      if (!res.ok) throw new Error('Failed to load product');
      return res.json();
    })
    .then(data => {
      hideLoading(overlay);
      renderQuickView(overlay, data, contextPath);
      
      // Show with animation
      requestAnimationFrame(() => {
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
      });
    })
    .catch(() => {
      // Fallback: redirect to product detail page
      window.location.href = `${contextPath || window.CONTEXT_PATH || ''}/product?id=${productId}`;
    })
    .finally(() => {
      isLoading = false;
    });
  }

  function renderQuickView(overlay, data, contextPath) {
    const cp = contextPath || window.CONTEXT_PATH || '';
    const imageBox = overlay.querySelector('.quick-view-image');
    const infoBox = overlay.querySelector('.quick-view-info');

    const hasDiscount = data.discountValue && data.discountValue !== '0';
    const ratingStars = generateStars(data.averageRating || 0);

    imageBox.innerHTML = `
      <img src="${data.mainImageUrl || data.image}" alt="${data.name}" loading="lazy" />
    `;

    infoBox.innerHTML = `
      <h3 class="product-title">
        <a href="${cp}/product?id=${data.id}">${data.name}</a>
      </h3>
      
      <div class="quick-rating">
        <span class="stars">${ratingStars}</span>
        <span>${data.averageRating ? data.averageRating.toFixed(1) : '0.0'}</span>
        <span>(${data.totalReviews || 0} đánh giá)</span>
      </div>
      
      <div class="quick-price">
        <span class="current">${data.finalPrice}</span>
        ${hasDiscount ? `<span class="original">${data.price}</span>` : ''}
        ${hasDiscount ? `<span class="discount">${data.discountValue}</span>` : ''}
      </div>
      
      <div class="quick-description">
        ${data.shortDescription || data.description || ''}
      </div>
      
      <div class="quick-options">
        ${data.colors && data.colors.length > 0 ? `
          <div class="quick-option-row">
            <label>Màu sắc:</label>
            <div class="quick-colors">
              ${data.colors.map(c => `
                <span class="color-swatch ${c.selected ? 'selected' : ''}" 
                      style="background:${c.hexCode}" 
                      title="${c.name}"
                      data-color-id="${c.id}"></span>
              `).join('')}
            </div>
          </div>
        ` : ''}
        
        ${data.sizes && data.sizes.length > 0 ? `
          <div class="quick-option-row">
            <label>Kích thước:</label>
            <div class="quick-sizes">
              ${data.sizes.map(s => `
                <span class="size-opt ${s.selected ? 'selected' : ''}" 
                      data-size-id="${s.id}">${s.name}</span>
              `).join('')}
            </div>
          </div>
        ` : ''}
      </div>
      
      <div class="quick-actions">
        <button class="qv-btn qv-btn-add" data-product-id="${data.id}">
          <ion-icon name="cart-outline"></ion-icon> Thêm vào giỏ
        </button>
        <a href="${cp}/product?id=${data.id}" class="qv-btn qv-btn-view">
          <ion-icon name="eye-outline"></ion-icon> Xem chi tiết
        </a>
      </div>
    `;

    // Add to cart handler
    const addBtn = infoBox.querySelector('.qv-btn-add');
    if (addBtn) {
      addBtn.addEventListener('click', function () {
        const selectedSize = infoBox.querySelector('.size-opt.selected');
        const selectedColor = infoBox.querySelector('.color-swatch.selected');
        
        if (!selectedSize) {
          showQvToast('⚠️ Vui lòng chọn kích thước!');
          return;
        }

        const productId = this.dataset.productId;
        const sizeId = selectedSize.dataset.sizeId;
        const colorId = selectedColor ? selectedColor.dataset.colorId : '';

        const params = new URLSearchParams();
        params.append('productId', productId);
        params.append('sizeId', sizeId);
        params.append('colorId', colorId);
        params.append('quantity', 1);

        this.disabled = true;
        this.textContent = 'Đang thêm...';

        fetch(`${cp}/cart/add`, {
          method: 'POST',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: params
        })
        .then(async res => {
          const data = await res.json();
          if (!res.ok) throw new Error(data.error || 'Có lỗi xảy ra');
          return data;
        })
        .then(data => {
          if (data.success) {
            showQvToast('🛒 Đã thêm vào giỏ hàng!');
            // Update cart badge
            updateCartBadge(data.cartCount);
            // Close quick view
            setTimeout(closeQuickView, 1000);
          }
        })
        .catch(err => {
          showQvToast('❌ ' + (err.message || 'Có lỗi xảy ra'));
          this.disabled = false;
          this.innerHTML = '<ion-icon name="cart-outline"></ion-icon> Thêm vào giỏ';
        });
      });
    }

    // Size selection
    infoBox.querySelectorAll('.size-opt').forEach(el => {
      el.addEventListener('click', function () {
        infoBox.querySelectorAll('.size-opt').forEach(s => s.classList.remove('selected'));
        this.classList.add('selected');
      });
    });

    // Color selection
    infoBox.querySelectorAll('.color-swatch').forEach(el => {
      el.addEventListener('click', function () {
        infoBox.querySelectorAll('.color-swatch').forEach(c => c.classList.remove('selected'));
        this.classList.add('selected');
      });
    });
  }

  function generateStars(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
      if (i <= rating) {
        html += '<i class="fas fa-star"></i>';
      } else if (i - 0.5 <= rating) {
        html += '<i class="fas fa-star-half-alt"></i>';
      } else {
        html += '<i class="far fa-star"></i>';
      }
    }
    return html;
  }

  function showQvToast(message) {
    const toast = document.getElementById('toast-message');
    if (toast) {
      toast.querySelector('span').textContent = message;
      toast.classList.add('show');
      setTimeout(() => toast.classList.remove('show'), 3000);
    }
  }

  function updateCartBadge(count) {
    if (!count) return;
    const badges = document.querySelectorAll('.cart-badge');
    if (badges.length > 0) {
      badges.forEach(b => { b.textContent = count; });
    }
  }

  // ---- Add quick view triggers to product cards ----
  function addQuickViewTriggers(container) {
    const root = container || document;
    
    // Add button to all product cards that don't have it
    root.querySelectorAll('.product-card:not(.qv-ready)').forEach(card => {
      card.classList.add('qv-ready');
      
      // Find the banner to position button
      const banner = card.querySelector('.card-banner');
      if (!banner) return;

      const trigger = document.createElement('button');
      trigger.className = 'quick-view-trigger';
      trigger.setAttribute('type', 'button');
      trigger.setAttribute('aria-label', 'Xem nhanh');
      trigger.innerHTML = '<ion-icon name="eye-outline"></ion-icon> Xem nhanh';
      
      // Get product ID from the link
      const link = card.querySelector('.card-title a') || card.querySelector('a[href*="product?id="]');
      if (link) {
        const match = link.getAttribute('href').match(/[?&]id=(\d+)/);
        if (match) {
          trigger.dataset.productId = match[1];
        } else {
          // Remove trigger if no product ID found
          return;
        }
      }

      banner.appendChild(trigger);

      trigger.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        const productId = this.dataset.productId;
        if (productId) {
          openQuickView(productId);
        }
      });
    });
  }

  // ---- Auto-init on DOM ready ----
  function init() {
    addQuickViewTriggers();

    // Watch for new product cards (e.g., after AJAX filter)
    const productObserver = new MutationObserver(() => {
      const container = document.getElementById('productsContainer') || 
                        document.getElementById('productList') ||
                        document.querySelector('.collection-grid');
      if (container) {
        addQuickViewTriggers(container);
      }
    });

    const target = document.getElementById('productsContainer') || 
                   document.body;
    productObserver.observe(target, { childList: true, subtree: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Expose
  window.QuickView = {
    open: openQuickView,
    close: closeQuickView,
    init: addQuickViewTriggers
  };
})();