/**
 * Product Image Zoom & Lightbox
 * - Hover zoom with magnifying lens (center follows mouse)
 * - Single click → opens fullscreen lightbox
 * - Lightbox also supports hover zoom with magnifying lens
 * - Keyboard navigation (arrows, escape)
 */
(function () {
  'use strict';

  const ZOOM = {
    lensSize: 120,
    zoomFactor: 2.5
  };

  let currentLightboxIndex = 0;
  let lightboxImages = [];
  let isLightboxOpen = false;

  // ---- ZOOM ENGINE (reusable for main page & lightbox) ----
  function attachZoomToImage(container, img) {
    if (!container || !img) return;

    // Create lens
    let lens = container.querySelector('.img-zoom-lens');
    if (!lens) {
      lens = document.createElement('div');
      lens.className = 'img-zoom-lens';
      container.appendChild(lens);
    }

    function updateZoomPosition(e) {
      const rect = img.getBoundingClientRect();
      const mouseX = e.clientX - rect.left;
      const mouseY = e.clientY - rect.top;

      const clampMin = 0;
      const clampMaxX = rect.width;
      const clampMaxY = rect.height;

      const clampedX = Math.max(clampMin, Math.min(mouseX, clampMaxX));
      const clampedY = Math.max(clampMin, Math.min(mouseY, clampMaxY));

      lens.style.left = clampedX + 'px';
      lens.style.top = clampedY + 'px';
      lens.style.backgroundImage = `url('${img.src}')`;

      const bgW = rect.width * ZOOM.zoomFactor;
      const bgH = rect.height * ZOOM.zoomFactor;

      const bgCenterX = clampedX * ZOOM.zoomFactor;
      const bgCenterY = clampedY * ZOOM.zoomFactor;

      const bgPosX = ZOOM.lensSize / 2 - bgCenterX;
      const bgPosY = ZOOM.lensSize / 2 - bgCenterY;

      lens.style.backgroundSize = `${bgW}px ${bgH}px`;
      lens.style.backgroundPosition = `${bgPosX}px ${bgPosY}px`;

      lens.classList.add('active');
      lens.style.opacity = '1';
    }

    function hideLens() {
      lens.style.opacity = '0';
      lens.classList.remove('active');
    }

    container.addEventListener('mousemove', updateZoomPosition);
    container.addEventListener('mouseleave', hideLens);

    return { updateZoomPosition, hideLens };
  }

  // ---- INIT MAIN GALLERY ----
  function initZoom(galleryContainer) {
    const container = galleryContainer || document.querySelector('.product-gallery-box');
    if (!container) return;

    const mainImgContainer = container.querySelector('.main-img-container');
    const mainImg = container.querySelector('#main-image');
    const subImgs = container.querySelectorAll('.sub-img-container img');

    if (!mainImgContainer || !mainImg) return;

    // Remove old zoom if exists (for re-init)
    const oldLens = container.querySelector('.img-zoom-lens');
    if (oldLens) oldLens.remove();

    // Wrap img in zoom container
    let zoomContainer = container.querySelector('.img-zoom-container');
    if (!zoomContainer) {
      zoomContainer = document.createElement('div');
      zoomContainer.className = 'img-zoom-container';
      mainImg.parentNode.insertBefore(zoomContainer, mainImg);
      zoomContainer.appendChild(mainImg);
    }

    // Attach zoom
    attachZoomToImage(zoomContainer, mainImg);

    mainImg.style.cursor = 'zoom-in';

    // Single click → open lightbox
    mainImgContainer.addEventListener('click', function (e) {
      if (!e.target.closest('.img-lightbox-overlay')) {
        openLightbox(getAllGalleryImages(container));
      }
    });

    // ---- Sub-image click handler ----
    const originalChangeImage = window.changeImage;
    window.changeImage = function (img) {
      mainImg.src = img.src;

      subImgs.forEach(s => s.classList.remove('active-thumb'));
      img.classList.add('active-thumb');

      // Re-attach zoom for new image
      const zc = container.querySelector('.img-zoom-container');
      if (zc) {
        const oldLens2 = zc.querySelector('.img-zoom-lens');
        if (oldLens2) oldLens2.remove();
        attachZoomToImage(zc, mainImg);
      }

      const allImages = getAllGalleryImages(container);
      const idx = allImages.findIndex(url => url === img.src);
      if (idx >= 0) currentLightboxIndex = idx;

      if (originalChangeImage) originalChangeImage(img);
    };

    if (subImgs.length > 0) {
      subImgs[0].classList.add('active-thumb');
    }
  }

  function getAllGalleryImages(container) {
    const imgs = container.querySelectorAll('.sub-img-container img, #main-image');
    const urls = [];
    imgs.forEach(img => {
      const url = img.src || img.getAttribute('src');
      if (url && !urls.includes(url)) urls.push(url);
    });
    return urls;
  }

  // ---- LIGHTBOX with zoom ----
  function openLightbox(images, startIndex) {
    if (!images || images.length === 0) return;

    lightboxImages = images;
    currentLightboxIndex = startIndex || 0;
    isLightboxOpen = true;

    const existing = document.querySelector('.img-lightbox-overlay');
    if (existing) existing.remove();

    const overlay = document.createElement('div');
    overlay.className = 'img-lightbox-overlay';

    const content = document.createElement('div');
    content.className = 'img-lightbox-content';

    // Zoom wrapper for the lightbox image
    const imgWrapper = document.createElement('div');
    imgWrapper.style.cssText = 'position:relative;display:inline-block;max-width:90vw;max-height:85vh;';

    const img = document.createElement('img');
    img.src = lightboxImages[currentLightboxIndex];
    img.alt = 'Product Image';
    img.style.cssText = 'max-width:90vw;max-height:85vh;object-fit:contain;border-radius:4px;cursor:crosshair;';
    imgWrapper.appendChild(img);

    // Lens for lightbox
    const lens = document.createElement('div');
    lens.className = 'img-zoom-lens';
    lens.style.cssText = 'position:absolute;width:120px;height:120px;border:2px solid rgba(255,255,255,0.6);border-radius:50%;background-repeat:no-repeat;pointer-events:none;z-index:10;opacity:0;box-shadow:0 0 20px rgba(0,0,0,0.4);transform:translate(-50%,-50%);transition:none;';
    imgWrapper.appendChild(lens);

    content.appendChild(imgWrapper);

    // Close button
    const closeBtn = document.createElement('button');
    closeBtn.className = 'img-lightbox-close';
    closeBtn.innerHTML = '&times;';
    closeBtn.setAttribute('aria-label', 'Close');
    content.appendChild(closeBtn);

    // Navigation
    if (lightboxImages.length > 1) {
      const prevBtn = document.createElement('button');
      prevBtn.className = 'img-lightbox-prev';
      prevBtn.innerHTML = '&#8249;';
      prevBtn.setAttribute('aria-label', 'Previous');
      content.appendChild(prevBtn);

      const nextBtn = document.createElement('button');
      nextBtn.className = 'img-lightbox-next';
      nextBtn.innerHTML = '&#8250;';
      nextBtn.setAttribute('aria-label', 'Next');
      content.appendChild(nextBtn);

      const counter = document.createElement('div');
      counter.className = 'img-lightbox-counter';
      counter.textContent = `${currentLightboxIndex + 1} / ${lightboxImages.length}`;
      content.appendChild(counter);
    }

    overlay.appendChild(content);
    document.body.appendChild(overlay);

    // Auto-fit: wait for image load then attach zoom
    function attachLightboxZoom() {
      const l = imgWrapper.querySelector('.img-zoom-lens');
      if (l) {
        // Re-attach fresh zoom
        const oldLens = imgWrapper.querySelector('.img-zoom-lens');
        if (oldLens) oldLens.remove();
        const newLens = document.createElement('div');
        newLens.className = 'img-zoom-lens';
        newLens.style.cssText = 'position:absolute;width:120px;height:120px;border:2px solid rgba(255,255,255,0.6);border-radius:50%;background-repeat:no-repeat;pointer-events:none;z-index:10;opacity:0;box-shadow:0 0 20px rgba(0,0,0,0.4);transform:translate(-50%,-50%);transition:none;';
        imgWrapper.appendChild(newLens);
      }

      function updateZoom(e) {
        const rect = img.getBoundingClientRect();
        const mx = e.clientX - rect.left;
        const my = e.clientY - rect.top;

        const cw = rect.width, ch = rect.height;
        const cx = Math.max(0, Math.min(mx, cw));
        const cy = Math.max(0, Math.min(my, ch));

        const lensEl = imgWrapper.querySelector('.img-zoom-lens');
        if (!lensEl) return;

        lensEl.style.left = cx + 'px';
        lensEl.style.top = cy + 'px';
        lensEl.style.backgroundImage = `url('${img.src}')`;
        lensEl.style.backgroundSize = `${cw * 3}px ${ch * 3}px`;
        lensEl.style.backgroundPosition = `${60 - cx * 3}px ${60 - cy * 3}px`;
        lensEl.style.opacity = '1';
        lensEl.classList.add('active');
      }

      function hideLens() {
        const lensEl = imgWrapper.querySelector('.img-zoom-lens');
        if (lensEl) {
          lensEl.style.opacity = '0';
          lensEl.classList.remove('active');
        }
      }

      imgWrapper.addEventListener('mousemove', updateZoom);
      imgWrapper.addEventListener('mouseleave', hideLens);
    }

    if (img.complete && img.naturalHeight > 0) {
      attachLightboxZoom();
    } else {
      img.onload = attachLightboxZoom;
    }

    requestAnimationFrame(() => overlay.classList.add('active'));
    document.body.style.overflow = 'hidden';

    // Event helpers
    function updateLightboxImage() {
      img.src = lightboxImages[currentLightboxIndex];
      // Re-attach zoom after image loads
      img.onload = function () {
        const lensEl = imgWrapper.querySelector('.img-zoom-lens');
        if (lensEl) lensEl.style.opacity = '0';
        attachLightboxZoom();
      };
      const counterEl = content.querySelector('.img-lightbox-counter');
      if (counterEl) counterEl.textContent = `${currentLightboxIndex + 1} / ${lightboxImages.length}`;
    }

    closeBtn.addEventListener('click', closeLightbox);

    const prevBtnEl = content.querySelector('.img-lightbox-prev');
    const nextBtnEl = content.querySelector('.img-lightbox-next');

    if (prevBtnEl) {
      prevBtnEl.addEventListener('click', (e) => {
        e.stopPropagation();
        currentLightboxIndex = (currentLightboxIndex - 1 + lightboxImages.length) % lightboxImages.length;
        updateLightboxImage();
      });
    }

    if (nextBtnEl) {
      nextBtnEl.addEventListener('click', (e) => {
        e.stopPropagation();
        currentLightboxIndex = (currentLightboxIndex + 1) % lightboxImages.length;
        updateLightboxImage();
      });
    }

    overlay.addEventListener('click', function (e) {
      if (e.target === overlay) closeLightbox();
    });

    document.addEventListener('keydown', lightboxKeyHandler);
  }

  function lightboxKeyHandler(e) {
    if (!isLightboxOpen) return;
    switch (e.key) {
      case 'Escape': closeLightbox(); break;
      case 'ArrowLeft':
        if (lightboxImages.length > 1) {
          e.preventDefault();
          currentLightboxIndex = (currentLightboxIndex - 1 + lightboxImages.length) % lightboxImages.length;
          const img = document.querySelector('.img-lightbox-content img');
          if (img) {
            img.src = lightboxImages[currentLightboxIndex];
            // Re-trigger zoom
            const evt = new Event('load');
            setTimeout(() => img.dispatchEvent(evt), 50);
          }
          const ce = document.querySelector('.img-lightbox-counter');
          if (ce) ce.textContent = `${currentLightboxIndex + 1} / ${lightboxImages.length}`;
        }
        break;
      case 'ArrowRight':
        if (lightboxImages.length > 1) {
          e.preventDefault();
          currentLightboxIndex = (currentLightboxIndex + 1) % lightboxImages.length;
          const img = document.querySelector('.img-lightbox-content img');
          if (img) {
            img.src = lightboxImages[currentLightboxIndex];
            const evt = new Event('load');
            setTimeout(() => img.dispatchEvent(evt), 50);
          }
          const ce = document.querySelector('.img-lightbox-counter');
          if (ce) ce.textContent = `${currentLightboxIndex + 1} / ${lightboxImages.length}`;
        }
        break;
    }
  }

  function closeLightbox() {
    const overlay = document.querySelector('.img-lightbox-overlay');
    if (overlay) {
      overlay.classList.remove('active');
      setTimeout(() => overlay.remove(), 300);
    }
    document.body.style.overflow = '';
    isLightboxOpen = false;
    document.removeEventListener('keydown', lightboxKeyHandler);
  }

  // ---- Auto-init ----
  function autoInit() {
    const gallery = document.querySelector('.product-gallery-box');
    if (gallery) initZoom(gallery);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', autoInit);
  } else {
    autoInit();
  }

  // Re-init when gallery updates dynamically
  const galleryObserver = new MutationObserver(() => {
    const gallery = document.querySelector('.product-gallery-box');
    if (gallery && !gallery.querySelector('.img-zoom-container')) {
      initZoom(gallery);
    }
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      const gallery = document.querySelector('.product-gallery-box');
      if (gallery) galleryObserver.observe(gallery, { childList: true, subtree: true });
    });
  } else {
    const gallery = document.querySelector('.product-gallery-box');
    if (gallery) galleryObserver.observe(gallery, { childList: true, subtree: true });
  }

  window.ImageZoom = {
    init: initZoom,
    openLightbox: openLightbox,
    closeLightbox: closeLightbox
  };
})();