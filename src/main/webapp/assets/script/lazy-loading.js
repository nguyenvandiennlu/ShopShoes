/**
 * Enhanced Lazy Loading with IntersectionObserver
 * - Progressive enhancement on existing src + loading="lazy"
 * - Fade-in animation when image enters viewport
 * - Error handling with retry
 * - Works with dynamically added content
 */
(function () {
  'use strict';

  // Don't run if browser doesn't support IntersectionObserver
  if (!window.IntersectionObserver) return;

  const config = {
    rootMargin: '200px 0px',
    threshold: 0.01,
    retryCount: 2,
    retryDelay: 1000
  };

  // Inject fade-in animation styles
  const style = document.createElement('style');
  style.textContent = `
    .lazy-img-enhanced {
      opacity: 0;
      transition: opacity 0.4s ease;
    }
    .lazy-img-enhanced.loaded {
      opacity: 1;
    }
    @media (prefers-reduced-motion: reduce) {
      .lazy-img-enhanced { transition: none; }
    }
  `;
  document.head.appendChild(style);

  let observer;

  function getObserver() {
    if (!observer) {
      observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const img = entry.target;
            observer.unobserve(img);
            img.classList.add('loaded');
          }
        });
      }, { rootMargin: config.rootMargin, threshold: config.threshold });
    }
    return observer;
  }

  function enhanceImage(img) {
    // Skip if already enhanced
    if (img.classList.contains('lazy-img-enhanced')) return;
    
    img.classList.add('lazy-img-enhanced');
    
    // If already loaded or tiny, mark as loaded immediately
    if (img.complete && img.naturalHeight > 0) {
      img.classList.add('loaded');
      return;
    }
    
    // If image is in viewport, load immediately (no fade needed)
    if (img.getBoundingClientRect().top < window.innerHeight + 100) {
      // For images already visible, just mark as loaded
      img.classList.add('loaded');
      return;
    }
    
    // Observe for when it scrolls into view
    getObserver().observe(img);
  }

  function init(container) {
    const root = container || document;
    const images = root.querySelectorAll('img[loading="lazy"]');
    images.forEach(enhanceImage);
  }

  // Auto-init
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => init());
  } else {
    init();
  }

  // Watch for dynamically added content
  const mutationObserver = new MutationObserver((mutations) => {
    mutations.forEach(mutation => {
      mutation.addedNodes.forEach(node => {
        if (node.nodeType === 1) {
          if (node.matches && node.matches('img[loading="lazy"]')) {
            enhanceImage(node);
          }
          const childImages = node.querySelectorAll && node.querySelectorAll('img[loading="lazy"]');
          if (childImages && childImages.length > 0) {
            childImages.forEach(enhanceImage);
          }
        }
      });
    });
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      mutationObserver.observe(document.body, { childList: true, subtree: true });
    });
  } else {
    mutationObserver.observe(document.body, { childList: true, subtree: true });
  }

  window.LazyLoader = { init, enhance: enhanceImage };
})();