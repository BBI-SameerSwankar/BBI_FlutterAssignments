import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_state.dart';

class CartTitleWidget extends StatelessWidget {
  const CartTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
