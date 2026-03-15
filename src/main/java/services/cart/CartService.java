package services.cart;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

import DTO.ProductDTO;
import dao.product.ProductVariantDao;
import jakarta.servlet.http.HttpSession;
import model.Promotion.PromotionResult;
import model.user.CartItem;
import services.product.ProductService;
import services.product.PromotionService;

public class CartService {

    private final ProductService productService = new ProductService();
    private final PromotionService promotionService = new PromotionService();
    private final ProductVariantDao variantDao = new ProductVariantDao();

    public void addToCart (
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
            CartItem item =
                    buildCartItem(productId, colorId, sizeId, qty);
            cart.put(key, item);
        }

        session.setAttribute("cart", cart);
    }

    public CartItem buildCartItem (
            int productId, int colorId, int sizeId, int qty) {

        ProductDTO product = productService.getProductById(productId);
        PromotionResult promo =
                promotionService.calculateBestPromotion(productId);

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

    public BigDecimal calculateTotal (Map<String, CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;

        for (CartItem item : cart.values()) {
            BigDecimal price = promotionService.parsePrice(item.getFinalPrice());
            total = total.add(
                    price.multiply(BigDecimal.valueOf(item.getQuantity()))
            );
        }
        return total;
    }

}
