import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/data/data_sources/remote_data_source.dart';
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  List<ProductModel>? _cachedProducts;

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    if (_cachedProducts != null) {
      return Right(_cachedProducts!);
    }

    try {
      final products = await remoteDataSource.fetchProducts();
      _cachedProducts = products;
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

    @override
  Future<Either<Failure, List<int>>> getFavouriteProductsId(String userId) async {
    try {
      final productIds = await remoteDataSource.getFavouriteProductsId(userId);
      return Right(productIds);
    } catch (e) {
      return Left(Failure('Failed to fetch favorite products'));
    }
  }
  
  @override
  Future<Either<Failure, void>> toggleFavorite(String userId, int productId, bool isFavorite) async {
      try {
      await remoteDataSource.toggleFavorite(userId, productId, isFavorite);
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to toggle favorite'));
    }
  }

   @override
  Future<void> addItemToCart(String userId, Cart cartItem) {

    return remoteDataSource.addItemToCart(userId, cartItem);
  }


 

  @override
  Future<void> removeItemFromCart(String userId, Cart cartItem) {
    return remoteDataSource.removeItemFromCart(userId, cartItem);
  }

  @override
  Future<List<Cart>> getCartItems(String userId) {
    return remoteDataSource.getCartItems(userId);
  }


}
