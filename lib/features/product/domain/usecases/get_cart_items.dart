
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class GetCartItems {
  final ProductRepository repository;

  GetCartItems(this.repository);

  Future<List<Cart>> call(String userId) {
    return repository.getCartItems(userId);
  }
}
