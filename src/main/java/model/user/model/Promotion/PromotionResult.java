package model.user.model.Promotion;

import java.math.BigDecimal;

public class PromotionResult {
    private BigDecimal finalPrice;
    private Promotion bestPromotion;

    public PromotionResult(BigDecimal finalPrice, Promotion bestPromotion) {
        this.finalPrice = finalPrice;
        this.bestPromotion = bestPromotion;
    }

    public PromotionResult() {
    }

    public BigDecimal getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(BigDecimal finalPrice) {
        this.finalPrice = finalPrice;
    }

    public Promotion getBestPromotion() {
        return bestPromotion;
    }

    public void setBestPromotion(Promotion bestPromotion) {
        this.bestPromotion = bestPromotion;
    }
}
