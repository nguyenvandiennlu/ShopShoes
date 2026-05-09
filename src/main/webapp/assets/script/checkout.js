document.addEventListener('DOMContentLoaded', function() {
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');
    const fullAddressInput = document.getElementById('fullAddress');
    const streetInput = document.getElementById('street');

    const shippingFeeDisplay = document.getElementById('shippingFeeDisplay');
    const grandTotalDisplay = document.getElementById('grandTotalDisplay');

    fetch(contextPath + '/api/location?type=province')
        .then(res => res.json())
        .then(data => {
            if (data.data) {
                data.data.forEach(item => {
                    provinceSelect.add(new Option(item.ProvinceName, item.ProvinceID));
                });
            }
        }).catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));

    provinceSelect.addEventListener('change', function() {
        districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
        wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
        districtSelect.disabled = true;
        wardSelect.disabled = true;

        if (this.value) {
            fetch(contextPath + '/api/location?type=district&parentId=' + this.value)
                .then(res => res.json())
                .then(data => {
                    if (data.data) {
                        data.data.forEach(item => {
                            districtSelect.add(new Option(item.DistrictName, item.DistrictID));
                        });
                        districtSelect.disabled = false;
                    }
                });
        }
        updateFullAddress();
    });

    districtSelect.addEventListener('change', function() {
        wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
        wardSelect.disabled = true;

        if (this.value) {
            fetch(contextPath + '/api/location?type=ward&parentId=' + this.value)
                .then(res => res.json())
                .then(data => {
                    if (data.data) {
                        data.data.forEach(item => {
                            wardSelect.add(new Option(item.WardName, item.WardCode));
                        });
                        wardSelect.disabled = false;
                    }
                });
        }
        updateFullAddress();
    });

    wardSelect.addEventListener('change', function() {
        updateFullAddress();

        if (this.value && districtSelect.value) {
            shippingFeeDisplay.innerText = "Đang tính...";

            let formData = new URLSearchParams();
            formData.append("district_id", districtSelect.value);
            formData.append("ward_code", this.value);

            fetch(contextPath + '/calculate-fee', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
                .then(res => res.json())
                .then(data => {
                    if(data.status === 'success') {
                        let fee = parseFloat(data.fee);
                        let grandTotal = subTotalRaw + fee;

                        const vndFormat = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

                        shippingFeeDisplay.innerText = vndFormat.format(fee);
                        grandTotalDisplay.innerText = vndFormat.format(grandTotal);
                    } else {
                        alert("Lỗi tính phí: " + data.message);
                        shippingFeeDisplay.innerText = "Chưa xác định";
                    }
                })
                .catch(err => {
                    console.error("Lỗi:", err);
                    shippingFeeDisplay.innerText = "Chưa xác định";
                });
        }
    });

    function updateFullAddress() {
        let pText = provinceSelect.options[provinceSelect.selectedIndex]?.text || '';
        let dText = districtSelect.options[districtSelect.selectedIndex]?.text || '';
        let wText = wardSelect.options[wardSelect.selectedIndex]?.text || '';
        let sText = streetInput.value.trim();

        let addressStr = [];
        if (sText) addressStr.push(sText);
        if (wText && wText !== 'Chọn Phường/Xã') addressStr.push(wText);
        if (dText && dText !== 'Chọn Quận/Huyện') addressStr.push(dText);
        if (pText && pText !== 'Chọn Tỉnh/Thành phố') addressStr.push(pText);

        fullAddressInput.value = addressStr.join(', ');
    }

    streetInput.addEventListener('input', updateFullAddress);
});