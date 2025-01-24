import 'package:flutter/material.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';

class ProductImageSection extends StatelessWidget {
  final ProductModel product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: product.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
