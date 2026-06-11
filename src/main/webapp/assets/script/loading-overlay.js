/**
 * Shared Loading Overlay functionality.
 * Manages showing/hiding a loading overlay popup with a spinner.
 *
 * Usage:
 *   showLoadingOverlay('overlayId', 'optional message');
 *   hideLoadingOverlay('overlayId');
 */
function showLoadingOverlay(overlayId, message) {
    var overlay = document.getElementById(overlayId || 'loadingOverlay');
    if (!overlay) return;

    if (message) {
        var textEl = overlay.querySelector('.loading-text');
        if (textEl) textEl.textContent = message;
    }

    overlay.classList.add('active');
    // Prevent background scrolling
    document.body.style.overflow = 'hidden';
}

function hideLoadingOverlay(overlayId) {
    var overlay = document.getElementById(overlayId || 'loadingOverlay');
    if (!overlay) return;

    overlay.classList.remove('active');
    document.body.style.overflow = '';
}