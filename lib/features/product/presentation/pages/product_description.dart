import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/bottom_navigation.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:sellphy/features/product/presentation/widgets/product_description_body.dart';
import 'package:sellphy/features/product/presentation/widgets/product_price_section.dart';
import 'package:sellphy/features/product/presentation/widgets/product_size_selector.dart';

class ProductDescriptionPage extends StatefulWidget {
  final ProductModel product;

  const ProductDescriptionPage({super.key, required this.product});

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.black,
            ),
            onPressed: () {
              BlocProvider.of<ProductBloc>(context)
                  .add(ToggleFavoriteEvent(widget.product.id));
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigationPage(initialIndex: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ProductDescriptionBody(product: widget.product),
            ProductPriceSection(product: widget.product),
        ],
      ),
    );
  }
}
