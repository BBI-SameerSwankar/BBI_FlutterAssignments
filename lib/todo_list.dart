import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/models/todo_model.dart';

import 'package:todo_app/todo_edit_form.dart'; // Import the edit form

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: true);

    // Function to show delete confirmation dialog
    void _showAlertDialog(BuildContext context, int index) {
      showDialog(
        context: context,
        barrierDismissible: false, // User must press a button to dismiss
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
                  todoProvider.deleteTodo(index); // Call the delete method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        // If the todo list is empty, show a message
        if (todoProvider.todos.isEmpty) {
          return const Center(
            child: Text(
              "There are no todos to be displayed",
              textAlign: TextAlign.center,
            ),
          );
        }

        // Display the list of todos
        return ListView.builder(
          itemCount: todoProvider.todos.length,
          itemBuilder: (BuildContext context, int index) {
            Todo todo = todoProvider.todos[index]; // Get the Todo object at the current index

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 135, 233),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Show the delete confirmation dialog
                        _showAlertDialog(context, index);
                      },
                      child: const Icon(Icons.delete),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Todo Edit form with the current todo item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoEditForm(todo: todo),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ],
                ),
                title: Text(
                  todo.title, // Use todo.title instead of todoProvider.data[index][0]
                  style: const TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  todo.description, // Use todo.description instead of todoProvider.data[index][1]
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
