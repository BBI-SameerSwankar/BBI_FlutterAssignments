import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  final String userId;

  const TaskScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, $userId")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Task Screen"),
            // Add your task-related UI here
          ],
        ),
      ),
    );
  }
}
