import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_bloc_app/service_locator.dart';
import 'package:todo_bloc_app/features/todo/presentation/pages/todo_insert_form.dart';
import 'package:todo_bloc_app/features/todo/presentation/pages/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // Ensure service locator is set up
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => GetIt.I<TodoBloc>()..add(TodoLoaded()), // Load todos when the app starts
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Todos App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: TodoList()), // TodoList will rebuild on state changes
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoInsertForm()),
          ).then((_) {
            // Reload the todos after inserting a new one
            context.read<TodoBloc>().add(TodoLoaded());
          });
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
