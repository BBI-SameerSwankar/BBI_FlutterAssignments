import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:sellphy/features/product/presentation/widgets/product_cart.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WishList"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final favoriteProducts = state.products
                  .where((product) => product.isFavorite)
                  .toList();

              return favoriteProducts.isEmpty
                  ? const Center(child: Text("No items in wishlist"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: favoriteProducts[index],
                          bgColor: Colors
                              .primaries[index % favoriteProducts.length]
                              .withOpacity(0.1),
                        );
                      },
                    );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
