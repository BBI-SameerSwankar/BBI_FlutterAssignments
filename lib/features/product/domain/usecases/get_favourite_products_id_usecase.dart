import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class GetFavouriteProductsIdUsercase {
  final ProductRepository productRepository;

  GetFavouriteProductsIdUsercase(this.productRepository);

  Future<Either<Failure, List<int>>> call(String userId) async {
    return await productRepository.getFavouriteProductsId(userId);
  }


}