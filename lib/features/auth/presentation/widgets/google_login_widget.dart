import 'package:flutter/material.dart';

class GoogleLoginIcon extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleLoginIcon({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/images/google_logo.png',
        height: 40, // Adjust size to match the registration page
        width: 40,  // Adjust size to match the registration page
      ),
    );
  }
}
