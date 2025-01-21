import 'package:flutter/material.dart';
import 'package:sellphy/features/product/presentation/pages/cart.dart';
import 'package:sellphy/features/product/presentation/pages/product_list.dart';
import 'package:sellphy/features/product/presentation/pages/wishlist.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_details.dart';

class BottomNavigationPage extends StatefulWidget {
  final int initialIndex;

  BottomNavigationPage({this.initialIndex = 0}); // Default to Home tab.

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    ProductList(),
    Cart(),
    Wishlist(),
    ProfileDetailsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Use the initial index.
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFEAF4F3), // Set the background color to #eaf4f3
          type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            activeIcon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 30),
            activeIcon: Icon(Icons.shopping_cart, size: 30),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 30),
            activeIcon: Icon(Icons.favorite, size: 30),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            activeIcon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
