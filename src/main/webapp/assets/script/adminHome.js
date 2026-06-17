document.addEventListener("DOMContentLoaded", function() {

    const presetButtons = document.querySelectorAll("#time-presets-group .control-chip");
    const inputStartDate = document.getElementById("input-start-date");
    const inputEndDate = document.getElementById("input-end-date");
    const btnApplyCustom = document.getElementById("btn-apply-custom");
    const chartYAxisSelect = document.getElementById("chartYAxisSelect");
    const btnCompareToggle = document.querySelector("#revenueCompareCard .btn-bittersweet");

    const kpiOrders = document.getElementById("kpi-orders");
    const growthOrders = document.getElementById("growth-orders");
    const kpiRevenue = document.getElementById("kpi-revenue");
    const growthRevenue = document.getElementById("growth-revenue");
    const kpiProducts = document.getElementById("kpi-products");
    const kpiLowStock = document.getElementById("kpi-lowstock-badge");
    const kpiCustomers = document.getElementById("kpi-customers");
    const growthUsers = document.getElementById("growth-users");

    let myChart = null;
    let isCompareModeActive = false;

    function formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    function renderGrowthBadge(element, growthValue) {
        if (!element) return;
        const val = (growthValue || 0).toFixed(1);
        if (growthValue > 0) {
            element.className = "ms-1 fw-bold text-success";
            element.innerText = `▲ ${val}%`;
        } else if (growthValue < 0) {
            element.className = "ms-1 fw-bold text-danger";
            element.innerText = `▼ ${Math.abs(val)}%`;
        } else {
            element.className = "ms-1 fw-bold text-secondary";
            element.innerText = `- 0%`;
        }
    }

    function loadKPIValues(startDate, endDate) {
        const url = `${window.contextPath}/admin/api/statistics?startDate=${startDate}&endDate=${endDate}`;
        fetch(url)
            .then(res => res.json())
            .then(data => {
                kpiOrders.innerText = new Intl.NumberFormat('vi-VN').format(data.totalOrders);
                kpiRevenue.innerText = new Intl.NumberFormat('vi-VN').format(data.totalRevenue) + " ₫";
                kpiCustomers.innerText = new Intl.NumberFormat('vi-VN').format(data.newUsers);
                kpiProducts.innerText = new Intl.NumberFormat('vi-VN').format(data.totalProducts);
                kpiLowStock.innerText = `${data.lowStockProducts} sắp hết`;

                renderGrowthBadge(growthOrders, data.ordersGrowth);
                renderGrowthBadge(growthRevenue, data.revenueGrowth);
                renderGrowthBadge(growthUsers, data.usersGrowth);
            }).catch(err => console.error(err));
    }

    function loadChartAnalytics(startDate, endDate) {
        const metric = chartYAxisSelect.value;
        const url = `${window.contextPath}/admin/api/chart-statistics?startDate=${startDate}&endDate=${endDate}&metric=${metric}`;

        const metricLabel = chartYAxisSelect.options[chartYAxisSelect.selectedIndex].text;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                const ctx = document.getElementById('dashboardAnalyticsChart').getContext('2d');

                if (myChart) {
                    myChart.destroy();
                }

                myChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [
                            {
                                label: `${metricLabel} (Kỳ này)`,
                                data: data.currentPeriodData,
                                borderColor: '#ff5a5f',
                                backgroundColor: 'rgba(255, 90, 95, 0.1)',
                                fill: true,
                                tension: 0.3,
                                borderWidth: 3,
                                pointRadius: 4
                            },
                            {
                                label: `${metricLabel} (Kỳ trước)`,
                                data: data.lastYearPeriodData,
                                borderColor: '#adb5bd',
                                backgroundColor: 'transparent',
                                fill: false,
                                tension: 0.3,
                                borderWidth: 2,
                                borderDash: [5, 5],
                                pointRadius: 3,
                                hidden: !isCompareModeActive
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: true, position: 'top' },
                            tooltip: { mode: 'index', intersect: false }
                        },
                        scales: {
                            y: { beginAtZero: true, grid: { color: '#f1f3f5' } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }).catch(err => console.error(err));
    }

    function refreshDashboard(startDate, endDate) {
        loadKPIValues(startDate, endDate);
        loadChartAnalytics(startDate, endDate);
        window.reloadProductStats(startDate, endDate);
    }

    const removePresetActive = () => presetButtons.forEach(btn => btn.classList.remove("active"));
    inputStartDate.addEventListener("change", removePresetActive);
    inputEndDate.addEventListener("change", removePresetActive);

    presetButtons.forEach(button => {
        button.addEventListener("click", function() {
            presetButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            const rangeType = this.getAttribute("data-range");
            const today = new Date();
            let startDate = "", endDate = formatDate(today);

            switch (rangeType) {
                case "today": startDate = formatDate(today); break;
                case "yesterday":
                    const yesterday = new Date(); yesterday.setDate(today.getDate() - 1);
                    startDate = formatDate(yesterday); endDate = formatDate(yesterday);
                    break;
                case "7days":
                    const sevenDaysAgo = new Date(); sevenDaysAgo.setDate(today.getDate() - 6);
                    startDate = formatDate(sevenDaysAgo); break;
                case "this-month":
                    startDate = formatDate(new Date(today.getFullYear(), today.getMonth(), 1)); break;
                case "this-year":
                    startDate = formatDate(new Date(today.getFullYear(), 0, 1)); break;
            }

            inputStartDate.value = startDate;
            inputEndDate.value = endDate;
            refreshDashboard(startDate, endDate);
        });
    });

    btnApplyCustom.addEventListener("click", function() {
        if (!inputStartDate.value || !inputEndDate.value) { alert("Vui lòng chọn ngày hợp lệ!"); return; }
        if (new Date(inputStartDate.value) > new Date(inputEndDate.value)) { alert("Ngày bắt đầu không được lớn hơn ngày kết thúc!"); return; }
        refreshDashboard(inputStartDate.value, inputEndDate.value);
    });

    chartYAxisSelect.addEventListener("change", function() {
        if (inputStartDate.value && inputEndDate.value) {
            loadChartAnalytics(inputStartDate.value, inputEndDate.value);
        }
    });

    btnCompareToggle.addEventListener("click", function() {
        isCompareModeActive = !isCompareModeActive;

        if (isCompareModeActive) {
            this.classList.remove("btn-bittersweet");
            this.classList.add("btn-dark");
            this.innerHTML = `Tắt đối sánh kỳ trước`;
        } else {
            this.classList.remove("btn-dark");
            this.classList.add("btn-bittersweet");
            this.innerHTML = `Thêm biểu đồ so sánh`;
        }

        if (myChart && myChart.data.datasets[1]) {
            myChart.data.datasets[1].hidden = !isCompareModeActive;
            myChart.update();
        }
    });

    function loadNewOrders() {
        const tbody = document.getElementById("new-orders-tbody");
        const countBadge = document.getElementById("new-orders-count");

        const url = `${window.contextPath}/admin/api/urgent-orders`;

        fetch(url)
            .then(res => res.json())
            .then(orders => {
                countBadge.innerText = `${orders.length} đơn mới`;

                if (orders.length === 0) {
                    tbody.innerHTML = `
                    <tr>
                        <td colspan="5" class="text-center py-4 text-secondary fw-semibold">
                            Không có đơn hàng mới nào.
                        </td>
                    </tr>`;
                    countBadge.className = "badge bg-secondary p-2";
                    return;
                }

                let html = "";
                orders.forEach(order => {
                    const formattedPrice = new Intl.NumberFormat('vi-VN').format(order.grand_total) + "₫";

                    let orderDate = "Vừa xong";
                    if(order.created_at) {
                        const dateObj = new Date(order.created_at);
                        const day = String(dateObj.getDate()).padStart(2, '0');
                        const month = String(dateObj.getMonth() + 1).padStart(2, '0');
                        const hours = String(dateObj.getHours()).padStart(2, '0');
                        const minutes = String(dateObj.getMinutes()).padStart(2, '0');
                        orderDate = `${day}/${month} ${hours}:${minutes}`;
                    }

                    let paymentBadge = "";
                    if (order.payment_status === "PAID") {
                        paymentBadge = `<span class="badge bg-success-subtle text-success border border-success-subtle px-1 rounded" style="font-size: 0.75rem;">Đã TT</span>`;
                    } else {
                        paymentBadge = `<span class="badge bg-warning-subtle text-warning border border-warning-subtle px-1 rounded" style="font-size: 0.75rem;">Chưa TT</span>`;
                    }

                    html += `
                    <tr>
                        <td class="fw-bold">
                            <a href="javascript:void(0)" onclick="showOrderDetail(${order.id})" class="text-primary text-decoration-none" title="Xem chi tiết">
                                #${order.id}
                            </a>
                       </td>
                        <td class="text-secondary">${orderDate}</td>
                        <td class="fw-bold text-bittersweet">${formattedPrice}</td>
                        <td class="text-center">${paymentBadge}</td>
                        <td class="text-center">
                            <button type="button" onclick="cancelOrder(${order.id})" class="btn btn-sm btn-outline-danger py-0 px-1 d-inline-flex align-items-center" title="Hủy đơn hàng này">
                                <span class="material-symbols-outlined" style="font-size: 18px;">cancel</span>
                            </button>
                        </td>
                    </tr>`;
                });
                tbody.innerHTML = html;
            })
            .catch(err => {
                console.error(err);
                tbody.innerHTML = `<tr><td colspan="5" class="text-center text-danger py-3">Lỗi tải dữ liệu.</td></tr>`;
            });
    }

    window.cancelOrder = function(orderId, fromModal = false) {
        if (confirm(`Bạn có chắc chắn muốn HỦY đơn hàng #${orderId} không?`)) {
            fetch(`${window.contextPath}/admin/api/orders/cancel`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `orderId=${orderId}`
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert("Đã hủy đơn hàng thành công!");
                        loadNewOrders();

                        if (fromModal) {
                            const modalEl = document.getElementById('orderDetailModal');
                            const modalInstance = bootstrap.Modal.getInstance(modalEl);
                            if (modalInstance) {
                                modalInstance.hide();
                            }
                        }
                    } else {
                        alert("Lỗi khi hủy: " + data.error);
                    }
                })
                .catch(err => alert("Lỗi kết nối!"));
        }
    };

    window.showOrderDetail = function(orderId) {
        const url = `${window.contextPath}/admin/api/orders/detail?id=${orderId}`;
        console.log("Đang gọi API tại URL:", url);

        fetch(url)
            .then(res => {
                // Nếu Server trả về lỗi HTTP (ví dụ 404 hoặc 500)
                if (!res.ok) {
                    throw new Error(`Server trả về mã lỗi HTTP: ${res.status}`);
                }
                return res.text(); // Đọc dạng chữ (text) trước để kiểm tra dữ liệu
            })
            .then(text => {
                let data;
                try {
                    data = JSON.parse(text); // Ép kiểu sang JSON
                } catch (e) {
                    console.error("Dữ liệu nhận được không phải JSON. Nội dung thực tế:", text);
                    throw new Error("Server không trả về JSON (Có thể trả về trang lỗi HTML)");
                }

                const order = data.order;
                const items = data.items;

                // 1. Đổ dữ liệu thông tin chung
                // 1. Đổ dữ liệu thông tin chung
                document.getElementById('modalOrderCode').innerText = `#${order.id}`;

                // Xử lý hiển thị Khách hàng (Hiển thị User ID và Số điện thoại nếu có)
                let customerInfo = `User #${order.user_id}`;
                if (order.phone_number) {
                    customerInfo += ` - SĐT: ${order.phone_number}`;
                }
                document.getElementById('modalCustomer').innerText = customerInfo;

                // Xử lý Ngày tạo
                let orderDate = "";
                if (order.created_at) {
                    orderDate = order.created_at.replace("T", " ").substring(0, 16);
                }
                document.getElementById('modalOrderDate').innerText = orderDate;

                // Xử lý Phương thức thanh toán (COD, VNPAY...) kèm trạng thái đã trả tiền chưa
                let paymentText = order.payment_method || "N/A";
                if (order.payment_status === "PAID") {
                    paymentText += ` (Đã TT)`;
                } else {
                    paymentText += ` (Chưa TT)`;
                }
                document.getElementById('modalPaymentMethod').innerText = paymentText;

                // Xử lý hiển thị Tổng tiền
                document.getElementById('modalOrderTotal').innerText = new Intl.NumberFormat('vi-VN').format(order.grand_total) + " ₫";

                // Xử lý Nhãn Trạng thái đơn hàng (Màu sắc trực quan)
                let statusHtml = "";
                switch (order.order_status) {
                    case 'NEW':
                        statusHtml = `<span class="badge bg-danger px-2">Mới (NEW)</span>`;
                        break;
                    case 'PROCESSING':
                        statusHtml = `<span class="badge bg-primary px-2">Đang xử lý</span>`;
                        break;
                    case 'SHIPPED':
                        statusHtml = `<span class="badge bg-info px-2">Đang giao</span>`;
                        break;
                    case 'DELIVERED':
                    case 'COMPLETED':
                        statusHtml = `<span class="badge bg-success px-2">Hoàn thành</span>`;
                        break;
                    case 'CANCELLED':
                        statusHtml = `<span class="badge bg-secondary px-2">Đã hủy</span>`;
                        break;
                    default:
                        statusHtml = `<span class="badge bg-dark px-2">${order.order_status}</span>`;
                }
                document.getElementById('modalOrderStatus').innerHTML = statusHtml;

                // 2. Đổ dữ liệu danh sách sản phẩm
                let itemsHtml = "";
                items.forEach(item => {
                    const price = new Intl.NumberFormat('vi-VN').format(item.unitPrice) + " ₫";
                    const img = item.imageUrl ? item.imageUrl : "https://via.placeholder.com/40";

                    itemsHtml += `
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <img src="${img}" width="40" height="40" class="rounded object-fit-cover border">
                                <span class="fw-medium text-dark" style="font-size: 0.9rem;">${item.productName}</span>
                            </div>
                        </td>
                        <td class="text-center text-secondary" style="font-size:0.85rem;">Màu: ${item.colorName || 'N/A'} <br> Size: ${item.sizeName || 'N/A'}</td>
                        <td class="text-center fw-bold">${item.quantity}</td>
                        <td class="text-end fw-medium text-bittersweet">${price}</td>
                    </tr>
                `;
                });
                document.getElementById('modalOrderItemsTbody').innerHTML = itemsHtml;

                // 3. Gắn sự kiện cho nút Hủy
                const btnCancel = document.getElementById('btnModalCancelOrder');
                btnCancel.onclick = function() {
                    cancelOrder(order.id, true);
                };

                // 4. Mở Modal công cụ Bootstrap
                const myModal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
                myModal.show();
            })
            .catch(err => {
                console.error("Lỗi chi tiết:", err);
                // Hiện thẳng lý do lỗi lên màn hình để dễ nhìn
                alert(`Lỗi hệ thống:\n- Lý do: ${err.message}\n\n(Hãy nhấn F12, vào mục Console hoặc Network để xem chi tiết)`);
            });
    };

    const defaultBtn = document.querySelector('[data-range="this-month"]');
    if (defaultBtn) defaultBtn.click();
    loadNewOrders();
});