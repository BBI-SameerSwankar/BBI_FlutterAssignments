import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/pages/register_user.dart';  // Import RegisterUser page

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
 

  // Form key to validate fields
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentication")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(CreateUserEvent());
              },
              child: Text("Create"),
            ),
            ElevatedButton(
              onPressed: () {
                // Show dialog to input userId when Login button is clicked
                _showLoginDialog(context);
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show dialog box for userId input
  void _showLoginDialog(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter User ID"),
          content: Form(
            key: _formKey,  // Attach the form key for validation
            child: TextFormField(
              controller: userIdController,
              decoration: InputDecoration(hintText: "Enter your User ID"),
              validator: (value) {
                // Validate user ID input
                if (value == null || value.isEmpty) {
                  return 'User ID cannot be empty';
                } else if (value.length < 3) {
                  return 'User ID must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate userId before login
                if (_formKey.currentState?.validate() ?? false) {
                  final userId = userIdController.text.trim();
             
                  context.read<AuthBloc>().add(LoginUserEvent(userId: userId));
                  Navigator.of(context).pop(); // Close the dialog after login
                } 
              },
              child: Text("Login"),
            ),
          ],
        );
      },
    );
  }
}
