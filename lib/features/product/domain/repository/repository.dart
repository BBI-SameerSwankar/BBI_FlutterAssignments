import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
}
