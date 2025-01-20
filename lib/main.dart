import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:sellphy/features/auth/presentation/bloc/auth_event.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_state.dart';
import 'package:sellphy/features/auth/presentation/pages/login_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/signup_screen.dart';
import 'package:sellphy/features/product/presentation/cart.dart';
import 'package:sellphy/features/product/presentation/product_list.dart';
import 'package:sellphy/features/product/presentation/wishlist.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_details.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_form.dart';
import 'package:sellphy/firebase_options.dart';
import 'package:sellphy/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  print("setup done");
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
            create: (_) {
              print("getting profile event  ccalled");
            return locator<ProfileBloc>()..add(GetProfileEvent());
            } 
            ),
      ],
      child: MaterialApp(
        initialRoute: '/', // Start with the AuthWrapper
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/profileform': (context) => ProfileForm(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final int initialTabIndex;

  AuthWrapper({this.initialTabIndex = 0}); // Default to Home tab.

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthSignedIn) {

            print("this is going to work./.......");
            BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {

                print(profileState);
              if (profileState is ProfileStatusIncompleteState) {
                return ProfileForm(isEdit: false);
              } else if (profileState is ProfileSetupComplete)
              {
                return BottomNavigationPage(initialIndex: 0);

              } else if(
                  profileState is ProfileUpdateSucess) {
                return BottomNavigationPage(initialIndex: initialTabIndex);
              }

              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
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
