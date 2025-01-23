import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/bottom_navigation.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';

class ProductDescriptionPage extends StatefulWidget {
  final ProductModel product;

  const ProductDescriptionPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {

  late bool isLiked;

  @override
  void initState() {
    // TODO: implement initState
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
              color: isLiked ? Colors.pink : Colors.black, 
      
            ),
            onPressed: () {
              BlocProvider.of<ProductBloc>(context).add(ToggleFavoriteEvent( widget.product.id));
              setState(() {
                  isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,MaterialPageRoute(builder: 
              (context)=> BottomNavigationPage(initialIndex: 1)
              ));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  
                  child: Container(
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(
                              widget.product.rate.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              ' (321 reviews)', 
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.product.description,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Size",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: ["XS", "S", "M", "L", "XL"].map((size) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(size),
                                    selected: size == "M", 
                                    onSelected: (selected) {
                                      // Handle size selection
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                    
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 30, top: 16, right: 0, bottom: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "30% Offer",
                        style: TextStyle(
                          fontSize: 20, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "£${(widget.product.price * 1.43).toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 18, 
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "£${widget.product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          
                          BlocProvider.of<CartBloc>(context).add(AddToCartEvent(productId: widget.product.id, quantity: 1));

                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18, 
                          ),
                          minimumSize: const Size(120, 56), 
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 18, color: Colors.white), 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
