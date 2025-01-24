import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/widgets/cart_item_widget.dart';
import 'package:sellphy/features/product/presentation/widgets/cart_summary_widget.dart';
import 'package:sellphy/features/product/presentation/widgets/cart_title_widget.dart';
import 'package:sellphy/features/product/presentation/widgets/cart_empty_widget.dart';
import 'package:sellphy/features/product/presentation/widgets/cart_error_widget.dart';
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
        title: const CartTitleWidget(),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const CartEmptyWidget();
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(cartItem: state.cartItems[index]);
                    },
                  ),
                ),
                CartSummaryWidget(cartState: state),
              ],
            );
          } else if (state is CartError) {
            return CartErrorWidget(message: state.message);
          }
          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }
}
