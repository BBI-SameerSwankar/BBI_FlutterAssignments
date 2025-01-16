import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_out.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_event.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_state.dart';
import 'package:sellphy/features/auth/presentation/pages/home_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/login_screen.dart';
import 'package:sellphy/features/auth/presentation/pages/signup_screen.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_form.dart';
import 'package:sellphy/firebase_options.dart';
import 'package:sellphy/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        BlocProvider(create: (_) => locator<ProfileBloc>()..add(CheckProfileStatusEvent())),
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
          print("loading....");
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthSignedIn) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              print("in bloc");
              print(state);
              if(state is ProfileStatusIncompleteState)
              {
                  return  ProfileForm();
              }
              if(state is ProfileStatusCompleteState)
              {
                  return  HomeScreen();
              }
              else{
                 return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
              }

            },
          );
          // return ProfileForm();
        } else if (state is AuthError) {
          print("error...");
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
