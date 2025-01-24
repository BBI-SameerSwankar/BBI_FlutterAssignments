import 'package:flutter/material.dart';

class CartErrorWidget extends StatelessWidget {
  final String message;

  const CartErrorWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
