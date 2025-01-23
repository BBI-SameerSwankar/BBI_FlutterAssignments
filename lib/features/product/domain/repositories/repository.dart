import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/domain/entities/cart.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<void> addItemToCart(String userId, Cart cartItem);
  Future<void> removeItemFromCart(String userId, Cart cartItem);
  Future<List<Cart>> getCartItems(String userId);
  Future<Either<Failure,void>> toggleFavorite(String userId,int productId,bool isFavorite);
  Future<Either<Failure,List<int>>> getFavouriteProductsId(String userId);
}
