package services.cart;

import DTO.ProductDTO;
import dao.cart.CartDao;
import dao.cart.CartItemRow;
import dao.product.ProductVariantDao;
import jakarta.servlet.http.HttpSession;
import model.Promotion.PromotionResult;
import model.cart.CartItem;
import services.product.ProductService;
import services.product.PromotionService;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CartService {

    private final ProductService productService = new ProductService();
    private final PromotionService promotionService = new PromotionService();
    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final CartDao cartDao = new CartDao();

    public void addToCart(
            HttpSession session,
            int productId,
            int colorId,
            int sizeId,
            int qty
    ) {
        Map<String, CartItem> cart =
                (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new LinkedHashMap<>();
        }

        String key = productId + "-" + colorId + "-" + sizeId;

        if (cart.containsKey(key)) {
            CartItem item = cart.get(key);
            item.setQuantity(item.getQuantity() + qty);
        } else {
            CartItem item = buildCartItem(productId, colorId, sizeId, qty);
            cart.put(key, item);
        }

        session.setAttribute("cart", cart);
    }

    public CartItem buildCartItem(int productId, int colorId, int sizeId, int qty) {

        ProductDTO product = productService.getProductById(productId);
        PromotionResult promo = promotionService.calculateBestPromotion(productId);

        CartItem item = new CartItem();
        item.setProductId(productId);
        item.setColorId(colorId);
        item.setSizeId(sizeId);

        item.setName(product.getName());
        item.setImage(product.getMainImageUrl());

        item.setColorName(variantDao.getColorName(colorId));
        item.setSizeName(variantDao.getSizeName(sizeId));

        item.setOriginalPrice(product.getPrice());
        item.setFinalPrice(
                promotionService.formatVND(promo.getFinalPrice())
        );
        item.setDiscountValue(
                promotionService.getDiscountValueString(
                        promo.getBestPromotion())
        );

        item.setQuantity(qty);
        return item;
    }

    public BigDecimal calculateTotal(Map<String, CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;

        for (CartItem item : cart.values()) {
            BigDecimal price = promotionService.parsePrice(item.getFinalPrice());
            total = total.add(
                    price.multiply(BigDecimal.valueOf(item.getQuantity()))
            );
        }
        return total;
    }

    public void loadDbCartToSession(HttpSession session, int userId) {
        List<CartItemRow> rows = cartDao.findItemsByUserId(userId);

        Map<String, CartItem> cart = new LinkedHashMap<>();
        for (CartItemRow r : rows) {
            CartItem item = buildCartItem(r.getProductId(), r.getColorId(), r.getSizeId(), r.getQuantity());
            cart.put(item.getKey(), item);
        }
        session.setAttribute("cart", cart);
    }

    public void mergeSessionIntoDbThenReload(HttpSession session, int userId) {
        Map<String, CartItem> sessionCart = (Map<String, CartItem>) session.getAttribute("cart");

        if (sessionCart != null) {
            for (CartItem item : sessionCart.values()) {
                BigDecimal unitPrice = promotionService.parsePrice(item.getFinalPrice());
                cartDao.upsertItem(userId, item.getProductId(), item.getColorId(), item.getSizeId(), item.getQuantity(), unitPrice);
            }
        }

        loadDbCartToSession(session, userId);
    }

    public void syncAdd(HttpSession session, int userId, int productId, int colorId, int sizeId, int qty) {
        addToCart(session, productId, colorId, sizeId, qty);
        CartItem item = buildCartItem(productId, colorId, sizeId, qty);
        BigDecimal unitPrice = promotionService.parsePrice(item.getFinalPrice());
        cartDao.upsertItem(userId, productId, colorId, sizeId, qty, unitPrice);
    }

    public void syncUpdate(HttpSession session, int userId, String key, String action) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null || !cart.containsKey(key)) return;
        CartItem item = cart.get(key);
        int newQty = item.getQuantity();
        if ("plus".equals(action)) newQty++;
        if ("minus".equals(action) && newQty > 1) newQty--;
        item.setQuantity(newQty);
        session.setAttribute("cart", cart);
        String[] p = key.split("-");
        int productId = Integer.parseInt(p[0]);
        int colorId = Integer.parseInt(p[1]);
        int sizeId = Integer.parseInt(p[2]);
        cartDao.updateQuantity(userId, productId, colorId, sizeId, newQty);
    }

    public void syncRemove(HttpSession session, int userId, String key) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            return;
        }
        cart.remove(key);
        session.setAttribute("cart", cart);
        String[] p = key.split("-");
        int productId = Integer.parseInt(p[0]);
        int colorId = Integer.parseInt(p[1]);
        int sizeId = Integer.parseInt(p[2]);
        cartDao.removeItem(userId, productId, colorId, sizeId);
    }
}
