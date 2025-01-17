import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:sellphy/features/auth/presentation/bloc/auth_event.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_state.dart';
import 'package:sellphy/features/auth/presentation/pages/home_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/login_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/signup_screen.dart';
import 'package:sellphy/features/product/presentation/cart.dart';
import 'package:sellphy/features/product/presentation/product_list.dart';
import 'package:sellphy/features/product/presentation/profile.dart';
import 'package:sellphy/features/product/presentation/wishlist.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_form.dart';
import 'package:sellphy/firebase_options.dart';
import 'package:sellphy/injection_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => locator<AuthBloc>()..add(GetUserIdFromLocal())),
        BlocProvider(
            create: (_) => locator<ProfileBloc>()..add(GetProfileEvent())),
      ],
      child: MaterialApp(
        initialRoute: '/', // Start with the AuthWrapper
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => ProfileForm(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
   
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthSignedIn) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
  
              if (state is ProfileStatusCompleteState) {
                return BottomNavigationPage();
              } else if (state is ProfileInitialState ||
                  state is ProfileLoadingState) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              return ProfileForm(); 
            },
          );
        } else if (state is AuthError) {
    
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProductList(),
    Cart(),
    Wishlist(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'E-Commerce App',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 24,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Colors.red,
      //   centerTitle: true,
      //   elevation: 10,
      // ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
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
      ),
    );
  }
}
