import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/utils/theme.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/pages/authentication_page.dart';
import 'package:task_app/features/auth/presentation/pages/register_user.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/pages/tast_screen.dart';
import 'package:task_app/features/task/presentation/pages/add_task_screen.dart';
import 'package:task_app/features/task/presentation/pages/edit_task_screen.dart';
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
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthStateWrapper(),
          '/auth': (context) => const AuthenticationPage(),
          // '/register': (context) => const RegisterUser(),
        },
        // Use onGenerateRoute to pass the userId explicitly to TaskScreen, AddTaskScreen, and EditTaskScreen
        onGenerateRoute: (settings) {
          if (settings.name == '/tasks') {
            // Ensure the userId is passed through arguments
            final userId = settings.arguments as String?;
            if (userId != null) {
              return MaterialPageRoute(
                builder: (context) => TaskScreen(userId: userId),
              );
            }
          }
          if (settings.name == '/addTask') {
            // Ensure userId is passed through arguments
            final userId = settings.arguments as String?;
            if (userId != null) {
              return MaterialPageRoute(
                builder: (context) => AddTaskScreen(userId: userId),
              );
            }
          }
          if (settings.name == '/editTask') {
            // Ensure task and userId are passed through arguments
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args['userId'] != null && args['task'] != null) {
              final userId = args['userId'] as String;
              final task = args['task'] as TaskModel;
              return MaterialPageRoute(
                builder: (context) => EditTaskScreen(userId: userId, task: task),
              );
            }
          }
          return null; // Return null if no matching route is found
        },
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
          // When the user is logged in, navigate to the TaskScreen with userId
          return TaskScreen(userId: state.userId);
        } else if (state is UserRegister) {
          return const RegisterUser();
        } else if (state is AuthError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        });
        return const AuthenticationPage();
        }
        return Container();
      },
    );
  }
}
