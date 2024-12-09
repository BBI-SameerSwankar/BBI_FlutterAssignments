import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:todo_bloc_app/features/todo/presentation/pages/todo_edit_form.dart';
import 'package:todo_bloc_app/features/todo/data/models/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    print("todolist.....");

    // Using BlocBuilder to listen to TodoBloc state changes
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // Handling the different states
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TodoError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is TodoLoadedState) {
          final todoList = state.todos;

          if (todoList.isEmpty) {
            return const Center(
              child: Text(
                "There are no todos to be displayed.",
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = todoList[index];

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
                      // Edit Button
                      GestureDetector(
                        onTap: () {
                          // Navigate to the Todo Edit form
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoEditForm(todo: todo),
                            ),
                          ).then((_) {
                            // Reload the todos after editing
                            context.read<TodoBloc>().add(TodoLoaded());
                          });
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 10),
                      // Delete Button
                      GestureDetector(
                        onTap: () {
                          // Show delete confirmation dialog
                          _showAlertDialog(context, todo.id);
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

        // Default fallback to an empty container (should never happen)
        return const SizedBox();
      },
    );
  }

  // Function to show delete confirmation dialog
  void _showAlertDialog(BuildContext context, int todoId) {
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
                // Dispatch DeleteTodoEvent to delete the todo by its ID
                context.read<TodoBloc>().add(DeleteTodoEvent(id: todoId));
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
