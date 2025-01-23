import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class ToggleFavouriteUsecase {

  final ProductRepository productRepository;

  ToggleFavouriteUsecase(this.productRepository);

  Future<Either<Failure, void>> call(String userId,int productId,bool isFavorite) async {
    return await productRepository.toggleFavorite(userId, productId, isFavorite);
  }
}