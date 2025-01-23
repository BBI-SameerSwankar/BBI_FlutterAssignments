import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/auth_wrapper.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:sellphy/features/auth/presentation/bloc/auth_event.dart';
import 'package:sellphy/features/auth/presentation/pages/login_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/signup_screen.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';

import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_form.dart';

import 'package:sellphy/firebase_options.dart';
import 'package:sellphy/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  debugPrint("setup done");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<AuthBloc>()..add(GetUserIdFromLocal())),
        BlocProvider(create: (_) => locator<ProfileBloc>()),
        BlocProvider(create: (_) => locator<ProductBloc>()..add(GetProductEvent())),
        BlocProvider(create: (_) => locator<CartBloc>()..add(GetProductEventForCart())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', 
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
