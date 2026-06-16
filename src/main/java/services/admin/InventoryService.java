package services.admin;

import dao.admin.InventoryDao;
import model.admin.InventoryProductRow;

import java.util.List;

public class InventoryService {

    private final InventoryDao inventoryDao = new InventoryDao();
    private static final int PAGE_SIZE = 10;

    public static class InventoryPageResult {
        public final List<InventoryProductRow> rows;
        public final int totalCount;
        public final int totalPages;
        public final int currentPage;

        public InventoryPageResult(List<InventoryProductRow> rows,
                                   int totalCount, int currentPage) {
            this.rows        = rows;
            this.totalCount  = totalCount;
            this.currentPage = currentPage;
            this.totalPages  = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        }
    }

    public InventoryPageResult getPage(
            String keyword,
            Integer brandId,
            Integer colorId,
            Integer sizeId,
            String stockStatus,
            String visible, int page
    ) {
        int offset = (page - 1) * PAGE_SIZE;
        List<InventoryProductRow> rows = inventoryDao.findWithFilter(
                keyword, brandId, colorId, sizeId, stockStatus, visible, PAGE_SIZE, offset);
        int total = inventoryDao.countWithFilter(
                keyword, brandId, colorId, sizeId, stockStatus, visible);
        return new InventoryPageResult(rows, total, page);
    }
}