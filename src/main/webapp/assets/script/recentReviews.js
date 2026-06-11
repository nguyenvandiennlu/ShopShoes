(function () {

    function timeAgo(dateStr) {
        if (!dateStr) return "";
        const diff = Math.floor((Date.now() - new Date(dateStr)) / 1000);
        if (diff < 60)     return "Vừa xong";
        if (diff < 3600)   return `${Math.floor(diff / 60)} phút trước`;
        if (diff < 86400)  return `${Math.floor(diff / 3600)} giờ trước`;
        if (diff < 604800) return `${Math.floor(diff / 86400)} ngày trước`;
        return new Date(dateStr).toLocaleDateString("vi-VN");
    }

    function renderStars(rating) {
        const r = parseInt(rating) || 0;
        return "★".repeat(r) + "☆".repeat(5 - r);
    }

    function renderReview(item) {
        const rating      = item.rating      || item.Rating      || 0;
        const content     = item.content     || item.Content     || "";
        const createdAt   = item.createdat   || item.createdAt   || item.created_at || "";
        const userName    = item.username    || item.userName    || item.full_name  || "Ẩn danh";
        const userEmail   = item.useremail   || item.userEmail   || "";
        const productName = item.productname || item.productName || "—";
        const productImg  = item.productimg  || item.productImg  || "";
        const verified    = item.isverifiedpurchase || item.isVerifiedPurchase || 0;

        const starColor   = rating >= 4 ? "text-warning" : rating >= 3 ? "text-secondary" : "text-danger";
        const displayName = userName || userEmail.split("@")[0] || "Ẩn danh";

        return `
        <div class="review-item">
            <div class="d-flex justify-content-between align-items-start mb-1">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white fw-bold"
                         style="width:30px;height:30px;font-size:13px;flex-shrink:0;">
                        ${displayName.charAt(0).toUpperCase()}
                    </div>
                    <div>
                        <span class="fw-semibold text-dark" style="font-size:13px;">${displayName}</span>
                        ${verified ? `<span class="badge bg-success-subtle text-success ms-1" style="font-size:10px;">✓ Đã mua</span>` : ""}
                    </div>
                </div>
                <span class="text-secondary" style="font-size:11px;white-space:nowrap;">${timeAgo(createdAt)}</span>
            </div>

            <div class="${starColor} mb-1" style="font-size:13px;" title="${rating}/5 sao">
                ${renderStars(rating)}
                <span class="text-secondary ms-1" style="font-size:11px;">${rating}/5</span>
            </div>

            <p class="text-secondary m-0" style="font-size:12px;
               display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;"
               title="${content}">
                ${content}
            </p>

            <div class="d-flex align-items-center gap-1 mt-1">
                ${productImg
            ? `<img src="${productImg}" width="16" height="16" class="rounded" style="object-fit:cover;">`
            : ""}
                <small class="text-muted" style="font-size:11px;
                    white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:180px;"
                    title="${productName}">
                    ${productName}
                </small>
            </div>
        </div>`;
    }

    async function loadRecentReviews() {
        const container = document.getElementById("recent-reviews-container");
        if (!container) return;

        container.innerHTML = `
            <div class="text-center py-3">
                <div class="spinner-border spinner-border-sm text-danger"></div>
            </div>`;

        try {
            const ctx  = window.contextPath || "";
            const res  = await fetch(`${ctx}/admin/api/recent-reviews`);
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const data = await res.json();

            if (!data.length) {
                container.innerHTML = `
                    <p class="text-center text-secondary py-3 m-0" style="font-size:13px;">
                        Chưa có đánh giá nào.
                    </p>`;
                return;
            }

            container.innerHTML = data.map(renderReview).join("");

        } catch (e) {
            console.error("loadRecentReviews:", e);
            container.innerHTML = `
                <p class="text-center text-danger py-3 m-0" style="font-size:13px;">
                    Lỗi tải đánh giá.
                </p>`;
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", loadRecentReviews);
    } else {
        loadRecentReviews();
    }

})();