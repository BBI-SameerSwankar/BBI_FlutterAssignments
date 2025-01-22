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
