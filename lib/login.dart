import 'package:flutter/material.dart';
import 'package:login_form_app/utils/email_validator.dart';
import 'package:login_form_app/utils/password_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordHidden = true;

  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[@$!%*?&#]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form is valid!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form is invalid!')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login form"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    controller: _emailController,
                    onChanged: (value) {
          
                      setState(() {
                        _email = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: emailValidator),
                    Row(
                      children: [
                EmailValidtor(email: _email),

                      ],
                    ),
                SizedBox(height: 30),
                TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordHidden,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          child: isPasswordHidden
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.visibility_off),
                        )),
                    validator: passwordValidator),

                  
                PasswordValidator(password: _password),
                SizedBox(height: 30),
                ElevatedButton(onPressed: onSubmit, child: Text("Submit")),
                SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}
