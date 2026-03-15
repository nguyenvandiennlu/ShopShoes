
    function updateCartBadge() {
    fetch('${pageContext.request.contextPath}/api/cart/count')
        .then(res => res.json())
        .then(data => {
            document.getElementById('cart-badge').innerText = data.count;
        });
}

    function updateWishlistBadge() {
    fetch('${pageContext.request.contextPath}/api/wishlist/count')
        .then(res => res.json())
        .then(data => {
            document.getElementById('wishlist-badge').innerText = data.count;
        });
}

