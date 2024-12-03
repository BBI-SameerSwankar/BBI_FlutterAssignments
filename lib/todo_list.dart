import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final todosProvider = Provider.of<TodoProvider>(context, listen: true);

 
    void _showAlertDialog(BuildContext context, int index) {
      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete ToDo'),
            content: Text('Are you sure you want to delete this ToDo item?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  
                  todosProvider.deleteTodo(index); 
                  Navigator.of(context).pop(); 
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.data.isEmpty) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "There are no todos to be displayed",
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return ListView.builder(
          itemCount: todoProvider.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 135, 233),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: ListTile(
                  trailing: GestureDetector(
                    onTap: () {
                      // Handle delete action
                      _showAlertDialog(context, index); // Pass index to dialog
                    },
                    child: const Icon(Icons.delete),
                  ),
                  title: Text(
                    "${todoProvider.data[index][0]}", // ToDo title
                    style: const TextStyle(fontSize: 22),
                  ),
                  subtitle: Text(
                    "${todoProvider.data[index][1]}", // ToDo description
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
