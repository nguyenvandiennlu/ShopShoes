(function () {
    const VND_FMT = new Intl.NumberFormat("vi-VN", {
        style: "currency", currency: "VND", maximumFractionDigits: 0
    });

    const TAB_META = {
        sold: {
            desc       : "Top 5 sản phẩm bán chạy nhất trong kỳ đã chọn.",
            colSold    : "SỐ LƯỢNG BÁN",
            colRevenue : "DOANH THU",
            emptyMsg   : "Chưa có đơn hàng hoàn thành trong kỳ này.",
        },
        unsold: {
            desc       : "Sản phẩm đang bán nhưng không có đơn hoàn thành nào trong kỳ.",
            colSold    : "SỐ LƯỢNG BÁN",
            colRevenue : "DOANH THU",
            emptyMsg   : "Tất cả sản phẩm đều đã bán được trong kỳ này! 🎉",
        },
        lowstock: {
            desc       : "Sản phẩm có ít nhất 1 biến thể hết hàng (🔴) hoặc sắp hết (⚠️ ≤ 5).",
            colSold    : "VARIANT HẾT",
            colRevenue : "VARIANT SẮP HẾT",
            emptyMsg   : "Tất cả sản phẩm đều còn hàng đầy đủ. ✅",
        },
    };

    let currentTab = "sold";

    function getCurrentDateRange() {
        const s = document.getElementById("input-start-date")?.value;
        const e = document.getElementById("input-end-date")?.value;
        return { start: s || "", end: e || "" };
    }

    function renderRow(item, index, tab) {
        const rank = index + 1;
        const medal = rank === 1 ? "🥇" : rank === 2 ? "🥈" : rank === 3 ? "🥉" : rank;

        const imgUrl      = item.imgurl      || item.imgUrl      || "";
        const productName = item.productname || item.productName || "—";
        const brandName   = item.brandname   || item.brandName   || "—";
        const totalSold   = Number(item.totalsold    || item.totalSold    || 0);
        const totalRev    = Number(item.totalrevenue || item.totalRevenue || 0);
        const totalStock  = Number(item.totalstock   || item.totalStock   || 0);
        const outVariants = Number(item.outofstockvariants || item.outOfStockVariants || 0);
        const lowVariants = Number(item.lowstockvariants   || item.lowStockVariants   || 0);

        const img = imgUrl
            ? `<img src="${imgUrl}" width="36" height="36"
                class="rounded border object-fit-cover me-2"
                onerror="this.src='https://via.placeholder.com/36'">`
            : `<span class="d-inline-block rounded border bg-light me-2" style="width:36px;height:36px;"></span>`;

        let col4 = "", col5 = "", stockCell = "";

        if (tab === "lowstock") {
            col4 = outVariants > 0
                ? `<span class="badge bg-danger">${outVariants} hết</span>`
                : `<span class="text-secondary">—</span>`;
            col5 = lowVariants > 0
                ? `<span class="badge bg-warning text-dark">${lowVariants} sắp hết</span>`
                : `<span class="text-secondary">—</span>`;
            stockCell = totalStock === 0
                ? `<span class="badge bg-danger">Hết hàng</span>`
                : `<span class="fw-semibold text-warning">${totalStock}</span>`;
        } else {
            col4 = `<span class="fw-bold ${tab === "sold" ? "text-success" : "text-secondary"}">
                    ${totalSold.toLocaleString("vi-VN")}
                </span>`;
            col5 = VND_FMT.format(totalRev);
            stockCell = totalStock === 0
                ? `<span class="badge bg-danger">Hết hàng</span>`
                : totalStock <= 5
                    ? `<span class="badge bg-warning text-dark">⚠ ${totalStock}</span>`
                    : `<span class="text-dark">${totalStock}</span>`;
        }

        return `
    <tr>
        <td class="text-center fw-bold" style="font-size:16px;">${medal}</td>
        <td>
            <div class="d-flex align-items-center">
                ${img}
                <span class="fw-semibold" style="font-size:14px;">${productName}</span>
            </div>
        </td>
        <td><span class="badge bg-light text-dark border">${brandName}</span></td>
        <td class="text-center">${col4}</td>
        <td class="text-end">${col5}</td>
        <td class="text-center">${stockCell}</td>
    </tr>`;
    }

    async function loadProductStats(tab, start, end) {
        const tbody = document.getElementById("product-stats-tbody");
        if (!tbody) return;

        tbody.innerHTML = `
            <tr><td colspan="6" class="text-center py-4">
                <div class="spinner-border spinner-border-sm text-danger me-2"></div>Đang tải...
            </td></tr>`;

        const meta = TAB_META[tab] || TAB_META.sold;

        const colSoldEl    = document.getElementById("col-sold-header");
        const colRevenueEl = document.getElementById("col-revenue-header");
        if (colSoldEl)    colSoldEl.textContent    = meta.colSold;
        if (colRevenueEl) colRevenueEl.textContent = meta.colRevenue;

        const descEl = document.getElementById("product-tab-desc");
        if (descEl) descEl.textContent = meta.desc;

        try {
            const ctx = window.contextPath || "";
            let url = `${ctx}/admin/api/product-stats?tab=${tab}&limit=5`;
            if (tab !== "lowstock" && start && end) {
                url += `&startDate=${start}&endDate=${end}`;
            }

            const res  = await fetch(url);
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const data = await res.json();

            if (!data.length) {
                tbody.innerHTML = `
                    <tr><td colspan="6" class="text-center py-4 text-secondary">
                        ${meta.emptyMsg}
                    </td></tr>`;
                return;
            }

            tbody.innerHTML = data.map((item, i) => renderRow(item, i, tab)).join("");

        } catch (e) {
            console.error("loadProductStats:", e);
            tbody.innerHTML = `
                <tr><td colspan="6" class="text-center text-danger py-3">
                    Lỗi tải dữ liệu
                </td></tr>`;
        }
    }

    function initProductStatsWidget() {
        const tabGroup = document.getElementById("product-tab-group");
        if (!tabGroup) return;

        tabGroup.querySelectorAll("[data-tab]").forEach(btn => {
            btn.addEventListener("click", () => {
                tabGroup.querySelectorAll("[data-tab]").forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                currentTab = btn.dataset.tab;
                const { start, end } = getCurrentDateRange();
                loadProductStats(currentTab, start, end);
            });
        });

        const { start, end } = getCurrentDateRange();
        loadProductStats(currentTab, start, end);
    }

    window.reloadProductStats = function (start, end) {
        loadProductStats(currentTab, start, end);
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initProductStatsWidget);
    } else {
        initProductStatsWidget();
    }
})();