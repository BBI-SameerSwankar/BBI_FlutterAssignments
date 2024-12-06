import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean/features/todo/presentation/provider/todo_provider.dart';
import 'package:todo_clean/service_locator.dart';
import 'package:todo_clean/features/todo/presentation/pages/todo_insert_form.dart';
import 'package:todo_clean/features/todo/presentation/pages/todo_list.dart';
// Todo App using clean architecture
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // Ensure service locator is set up
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
      create: (context) =>
          GetIt.I<TodoProvider>(), // Get TodoProvider from GetIt
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
  // late TodoProvider todoProvider;

  @override
  void initState() {
    super.initState();
    // todoProvider = GetIt.I<TodoProvider>();
    // todoProvider.getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    
     final todoProvider = Provider.of<TodoProvider>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: TodoList()), // Your todo list widget
      ),
    
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoInsertForm()),
          ).then((_) {
          
            todoProvider.getAllTodos();
          });
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
