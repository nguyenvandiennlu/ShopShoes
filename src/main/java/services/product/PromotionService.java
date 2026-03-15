package services.product;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.List;
import java.util.Locale;

import dao.product.ProductDao;
import dao.promotion.PromotionDao;
import model.Promotion.Promotion;
import model.Promotion.PromotionResult;
import model.product.Product;

public class PromotionService {
    ProductDao productDao = new ProductDao();
    PromotionDao promotionDao = new PromotionDao();

    public PromotionResult calculateBestPromotion(int productId) {
        Product product = productDao.findById(productId);
        if (product == null) {
            return new PromotionResult(BigDecimal.ZERO, null);
        }
        BigDecimal originalPrice = product.getPrice();
        if (originalPrice == null)
            originalPrice = BigDecimal.ZERO;
        List<Promotion> promotions = promotionDao.findPromotionForProduct(productId);
        if (promotions == null || promotions.isEmpty()) {
            return new PromotionResult(originalPrice, null);
        }
        BigDecimal bestPrice = originalPrice;
        Promotion bestPromotion = null;
        for (Promotion promo : promotions) {

            BigDecimal priceAfterPromo = originalPrice;
            if ("PERCENT".equalsIgnoreCase(promo.getDiscountType())) {
                BigDecimal discount = originalPrice
                        .multiply(promo.getDiscountValue())
                        .divide(BigDecimal.valueOf(100));
                priceAfterPromo = originalPrice.subtract(discount);

            } else if ("FIXED".equalsIgnoreCase(promo.getDiscountType())) {
                priceAfterPromo = originalPrice.subtract(promo.getDiscountValue());
            }
            if (priceAfterPromo.compareTo(BigDecimal.ZERO) < 0) {
                priceAfterPromo = BigDecimal.ZERO;
            }
            if (priceAfterPromo.compareTo(bestPrice) < 0) {
                bestPrice = priceAfterPromo;
                bestPromotion = promo; //
            }
        }

        return new PromotionResult(bestPrice, bestPromotion);
    }

    public String getDiscountValueString(Promotion promo) {
        if (promo == null || promo.getDiscountValue() == null) {
            return "";
        }
        BigDecimal value = promo.getDiscountValue();

        if ("PERCENT".equalsIgnoreCase(promo.getDiscountType())) {
            return value.stripTrailingZeros().toPlainString() + "%";
        }
        if ("FIXED".equalsIgnoreCase(promo.getDiscountType())) {
            return formatVND(value);
        }
        return "";
    }

    public String formatVND(BigDecimal value) {
        if (value == null)
            return "0₫";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.getDefault());
        symbols.setGroupingSeparator('.');

        DecimalFormat formatter = new DecimalFormat("#,###", symbols);
        return formatter.format(value) + "₫";
    }

    public BigDecimal parsePrice(String price) {
        if (price == null)
            return BigDecimal.ZERO;
        return new BigDecimal(price.replaceAll("[^0-9]", ""));
    }

}
