import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'add_task_screen.dart'; // Import the AddTaskScreen
import 'edit_task_screen.dart'; // Import the EditTaskScreen

class TaskScreen extends StatelessWidget {
  final String userId;

  const TaskScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Fetch tasks on screen load
    BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: userId));

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks for $userId"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else if (state is TaskLoadedState) {
            final tasks = state.tasks;
            if(tasks.length==0)
            { 
              return const Center(
              
              child: Text("No tasks added yet"),
              );
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('Due: ${task.dueDate}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to Edit Task Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(task: task),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle task deletion
                          print(index);
                          BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(userId: userId, task: task));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No tasks available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task Screen
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(userId: userId),
            ),
          )..then(
            (_){
                  BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: userId));
            }
           );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Implement the logout logic here
                BlocProvider.of<AuthBloc>(context).add(LogoutUserEvent());
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
