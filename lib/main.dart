import 'package:flutter/material.dart';
import 'package:profile_app/profile.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Profile"),),
        body: Center(
          child:  ProfilePage(),
        ),
      ),
    );
  }
}
