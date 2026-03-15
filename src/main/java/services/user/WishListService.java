package services.user;

import java.util.ArrayList;
import java.util.List;

import DTO.ProductDTO;
import dao.user.WishlistDao;
import model.user.WishList;
import services.product.ProductService;

public class WishListService {

    private final WishlistDao wishListDao = new WishlistDao();
    private final ProductService productService = new ProductService();

    public List<ProductDTO> getWishlistProducts(int userId) {

        List<WishList> wishlist = wishListDao.findByUser(userId);
        List<ProductDTO> result = new ArrayList<>();

        for (WishList w : wishlist) {
            ProductDTO dto =
                    productService.getProductById(w.getProductId());

            if (dto != null) {
                result.add(dto);
            }
        }

        return result;
    }

    public boolean add(int userId, int productId) {
        return wishListDao.add(userId, productId);
    }

    public boolean remove(int userId, int productId) {
        return wishListDao.remove(userId, productId);
    }

    public boolean exists(int userId, int productId) {
        return wishListDao.exists(userId, productId);
    }

}

