import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class GetFavouriteProductsIdUsecase {
  final ProductRepository productRepository;

  GetFavouriteProductsIdUsecase(this.productRepository);

  Future<Either<Failure, List<int>>> call(String userId) async {
    return await productRepository.getFavouriteProductsId(userId);
  }


}