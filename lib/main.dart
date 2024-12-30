import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';

import 'package:task_app/features/auth/presentation/pages/authentication_page.dart';
import 'package:task_app/features/auth/presentation/pages/register_user.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/pages/tast_screen.dart'; 
import 'package:task_app/firebase_options.dart';
import 'package:task_app/service_locator.dart'; 

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
        BlocProvider<TaskBloc>(
          create: (context) => locator<TaskBloc>(),
        ),
      ],
      child: const MaterialApp(
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
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthInitial) {
         
          return const AuthenticationPage();
        } else if (state is UserLoggedIn) {
         
          return TaskScreen(userId: state.userId);
        } else if (state is UserRegister) {

          return const RegisterUser();
        } else if (state is AuthError) {
         
          return Scaffold(
            body: Center(child: Text("Error: ${state.message}")),
          );
        }
        return Container();
      },
    ); 
  }
}

