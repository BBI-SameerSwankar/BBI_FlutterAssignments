
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class RemoveItemFromCart {
  final ProductRepository repository;

  RemoveItemFromCart(this.repository);

  Future<void> call(String userId, Cart cartItem) {
    return repository.removeItemFromCart(userId, cartItem);
  }
}
