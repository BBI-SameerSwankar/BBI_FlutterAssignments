import 'package:counter_app/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _counter = 0;

  
  
Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
       _counter = 0;
    });
  }

  void increaseCounter()
  {
    setState(() {
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("App Counter"),
          backgroundColor: Colors.amber,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,

          child: SingleChildScrollView(child: Homepage(counter : _counter))),
        floatingActionButton: FloatingActionButton(
          onPressed: increaseCounter,
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }
}
