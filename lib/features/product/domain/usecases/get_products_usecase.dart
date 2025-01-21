
import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/domain/repository/repository.dart';

class GetProductsUsecase {
  final ProductRepository productRepository;

  GetProductsUsecase(this.productRepository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await productRepository.getProducts();
  }
}