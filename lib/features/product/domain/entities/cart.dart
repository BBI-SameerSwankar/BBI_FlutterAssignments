import 'package:sellphy/features/product/domain/entities/product.dart';

class Cart {
  final int productId;
  final int quantity;
  ProductModel? product;

  Cart({
    required this.productId,
    required this.quantity,
    this.product
  });


  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }


  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }


   Cart copyWith({
    int? productId,
    int? quantity,
    ProductModel? product,
  }) {
    return Cart(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
