import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';

import 'package:task_app/features/auth/presentation/pages/authentication_page.dart';
import 'package:task_app/features/auth/presentation/pages/register_user.dart';
import 'package:task_app/features/task/presentation/pages/tast_screen.dart'; // Task screen
import 'package:task_app/firebase_options.dart';
import 'package:task_app/service_locator.dart'; // For dependency injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Set up dependencies
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => locator<AuthBloc>()..add(GetUserIdFromLocal()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthStateWrapper(),
      ),
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  const AuthStateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthInitial) {
          // Show the authentication screen (Login or Register page)
          return AuthenticationPage();
        } else if (state is UserLoggedIn) {
          // Show the main app screen with the user ID
          return TaskScreen(userId: state.userId);
        } else if (state is UserRegister) {
          // Show the register screen
          return RegisterUser();
        } else if (state is AuthError) {
          // Show error message
          return Scaffold(
            body: Center(child: Text("Error: ${state.message}")),
          );
        }
        return Container();
      },
    );
  }
}

