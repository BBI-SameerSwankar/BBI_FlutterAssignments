class CartEvent {}

class GetProductEventForCart extends CartEvent{}
class AddToCartEvent extends CartEvent {

  final int productId;
  final int quantity;

  AddToCartEvent({
    required this.productId,
    required this.quantity,
  });
}

class RemoveFromCartEvent extends CartEvent {

  final int productId;
  final int quantity;

  RemoveFromCartEvent({

    required this.productId,
    required this.quantity,
  });
}

class GetCartEvent extends CartEvent {

}

class UpdateCartQuantityEvent extends CartEvent {

}
