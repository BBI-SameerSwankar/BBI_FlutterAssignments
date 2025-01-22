

import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';

class AddItemToCart {
  final ProductRepository repository;

  AddItemToCart(this.repository);

  Future<void> call(String userId, Cart cartItem) {
    return repository.addItemToCart(userId, cartItem);
  }
}
