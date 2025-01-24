import 'package:flutter/material.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_state.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartLoaded cartState;

  const CartSummaryWidget({Key? key, required this.cartState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtotal = cartState.cartItems.fold(
      0.0,
      (total, cartItem) => total + (cartItem.product?.price ?? 0) * cartItem.quantity,
    );
    final shipping = 12.50;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF8F8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          _summaryRow("Sub total :", "£${subtotal.toStringAsFixed(2)}"),
          _summaryRow("Shipping :", "£${shipping.toStringAsFixed(2)}"),
          const Divider(height: 24, thickness: 1),
          _summaryRow("Bag Total :", "£${total.toStringAsFixed(2)}", bold: true),
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
              child: const Text("Checkout", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16.0, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 16.0, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: Colors.red)),
      ],
    );
  }
}
