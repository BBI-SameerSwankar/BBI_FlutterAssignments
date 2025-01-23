import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Cart",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final itemCount = state is CartLoaded ? state.cartItems.length : 0;
                return Text(
                  "$itemCount Items",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    
                  ),
                );
              },
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text("Your cart is empty."));
            }

            // Calculate totals
            double subtotal = state.cartItems.fold(
              0.0,
              (total, cartItem) =>
                  total + (cartItem.product?.price ?? 0) * cartItem.quantity,
            );
            double shipping = 12.50; // Fixed shipping cost
            double total = subtotal + shipping;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      final product = cartItem.product;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                color: Colors
                                    .primaries[cartItem.productId %
                                        Colors.primaries.length]
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
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "£${product?.price.toStringAsFixed(2) ?? '0.00'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "£105", // Placeholder for original price
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<CartBloc>(context).add(
                                            AddToCartEvent(
                                              productId: cartItem.productId,
                                              quantity: cartItem.quantity + 1,
                                            ),
                                          );
                                        },
                                        child: const CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Color(0xFFEEEEEE),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          "${cartItem.quantity}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (cartItem.quantity > 1) {
                                            BlocProvider.of<CartBloc>(context)
                                                .add(
                                              AddToCartEvent(
                                                productId: cartItem.productId,
                                                quantity: cartItem.quantity - 1,
                                              ),
                                            );
                                          } else {
                                            BlocProvider.of<CartBloc>(context)
                                                .add(
                                              RemoveFromCartEvent(
                                                productId: cartItem.productId,
                                                quantity: cartItem.quantity,
                                              ),
                                            );
                                          }
                                        },
                                        child: const CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Color(0xFFEEEEEE),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Delete button
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<CartBloc>(context).add(
                                  RemoveFromCartEvent(
                                    productId: cartItem.productId,
                                    quantity: cartItem.quantity,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom total section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF8F8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sub total :",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            "£${subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shipping :",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            "£${shipping.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Bag Total :",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "£${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }
}
