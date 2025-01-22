import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/cart_bloc/cart_event.dart';
import 'package:sellphy/features/product/presentation/cart_bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger the GetCartEvent when the CartPage is built
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Items", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
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
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = state.cartItems[index];
                final product = cartItem.product;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: ListTile(
                    leading: product?.image != null
                        ? Image.network(
                            product!.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.shopping_cart, size: 50),
                    title: Text(product?.title ?? "Unknown Product"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price: \$${product?.price.toStringAsFixed(2) ?? 'N/A'}"),
                        Text("Quantity: ${cartItem.quantity}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
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
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context).add(
                              AddToCartEvent(
                                productId: cartItem.productId,
                                quantity: cartItem.quantity + 1,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
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
