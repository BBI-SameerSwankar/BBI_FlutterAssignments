import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:sellphy/features/product/presentation/pages/product_description.dart';
import 'package:sellphy/features/product/presentation/widgets/product_cart.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              String username = "User";
              String? profileImage;

              if (profileState is ProfileStatusIncompleteState) {
                username = profileState.profileModel?.name ?? "User";
                profileImage = profileState.profileModel?.imageUrl;
              } else if (profileState is ProfileSetupComplete) {
                username = profileState.profileModel?.username ?? "User";
                profileImage = profileState.profileModel?.imageUrl;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage)
                        : null,
                    backgroundColor: Colors.red.shade100,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: state.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProductDescriptionPage(product: product),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const curve = Curves.easeInOut;
                            final tween = Tween(begin: 0.0, end: 1.0).chain(
                              CurveTween(curve: curve),
                            );
                            final scaleAnimation = animation.drive(tween);

                            return ScaleTransition(
                              scale: scaleAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Hero(
                      tag: product.id, // Unique tag
                      child: ProductCard(
                        key: ValueKey(product.id),
                        product: product,
                        bgColor: Colors
                            .primaries[index % Colors.primaries.length]
                            .withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is ProductError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
