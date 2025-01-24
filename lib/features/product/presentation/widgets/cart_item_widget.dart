import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_event.dart';

class CartItemWidget extends StatelessWidget {
  final Cart cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              color: Colors
                  .primaries[cartItem.productId % Colors.primaries.length]
                  .withOpacity(0.1),
              child: product?.image != null
                  ? Image.network(
                      product!.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.shopping_cart,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.title ?? "Unknown Product",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      "£${product?.price.toStringAsFixed(2) ?? '0.00'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _quantityButton(
                      context,
                      icon: Icons.add,
                      onPressed: () => BlocProvider.of<CartBloc>(context).add(
                        AddToCartEvent(
                          productId: cartItem.productId,
                          quantity: cartItem.quantity + 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${cartItem.quantity}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    _quantityButton(
                      context,
                      icon: Icons.remove,
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          BlocProvider.of<CartBloc>(context).add(
                            AddToCartEvent(
                              productId: cartItem.productId,
                              quantity: cartItem.quantity - 1,
                            ),
                          );
                        } else {
                          BlocProvider.of<CartBloc>(context).add(
                            RemoveFromCartEvent(
                              productId: cartItem.productId,
                              quantity: cartItem.quantity,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => BlocProvider.of<CartBloc>(context).add(
              RemoveFromCartEvent(
                productId: cartItem.productId,
                quantity: cartItem.quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Color(0xFFEEEEEE),
        child: Icon(Icons.add, color: Colors.black, size: 18),
      ),
    );
  }
}
