import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_clean/features/todo/data/models/todo.dart';
import 'package:todo_clean/features/todo/presentation/pages/todo_edit_form.dart';
import 'package:todo_clean/features/todo/presentation/provider/todo_provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TodoProvider from Provider
    print("todolist.....");
    final todoProvider = Provider.of<TodoProvider>(context);

    // Function to show delete confirmation dialog
    void _showAlertDialog(BuildContext context, int index) {
      showDialog(
        context: context,
        barrierDismissible: false, // User must press a button to dismiss
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete ToDo'),
            content: const Text('Are you sure you want to delete this ToDo item?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  todoProvider.deleteTodo(todoProvider.todos[index].id); // Pass the todo's id for deletion
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    if (todoProvider.todos.isEmpty) {
      return const Center(
        child: Text(
          "There are no todos to be displayed.",
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: todoProvider.todos.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = todoProvider.todos[index];

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
                    // Navigate to the Todo Edit form
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoEditForm(todo: todo),
                      ),
                    ).then((_){
                        todoProvider.getAllTodos();
                    });
                    
                  },
                  child: const Icon(Icons.edit),
                ),

                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showAlertDialog(context, index);
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
            title: Text(
              todo.title,
              style: const TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              todo.description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
