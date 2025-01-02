import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/utils/shared_preference_helper.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart'; // Import SharedPreferences helper
import 'add_task_screen.dart'; // Import the AddTaskScreen
import 'edit_task_screen.dart'; // Import the EditTaskScreen

class TaskScreen extends StatefulWidget {
  final String userId;

  const TaskScreen({super.key, required this.userId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _isAscending = true;
  String _selectedPriority = 'all'; // Store selected priority value here

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load preferences when screen is initialized
    // Fetch tasks on screen load
    BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: widget.userId));
  }

  // Load the preferences for sorting and priority filter
  void _loadPreferences() async {
    final isAscending = await SharedPreferencesHelper.getIsAscending();
    final selectedPriority =
        await SharedPreferencesHelper.getSelectedPriority();
    print("loading preferences...");
    print(selectedPriority);
    setState(() {
      _isAscending = isAscending;
      _selectedPriority = selectedPriority;
    });
  }

  // Function to get color based on priority
  Color _getPriorityDropdownColor(String priority) {
    switch (priority) {
      case 'low':
        return const Color.fromARGB(
            255, 192, 225, 193); // Green for low priority
      case 'medium':
        return const Color.fromRGBO(
            250, 230, 200, 1); // Orange for medium priority
      case 'high':
        return const Color.fromARGB(
            255, 255, 196, 192); // Red for high priority
      default:
        return Colors.grey; // Default color if unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks for ${widget.userId}",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
              // Save the sorting preference
              SharedPreferencesHelper.setIsAscending(_isAscending);
              BlocProvider.of<TaskBloc>(context)
                  .add(FilterTasksEvent(ascending: _isAscending));
            },
          ),
          // Dropdown for Priority Filter
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedPriority,
              dropdownColor: Colors.blueAccent,
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white),
              underline: SizedBox(),
              items: [
                'all',
                'low',
                'medium',
                'high',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      // Display the circular colored box next to the dropdown value
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getPriorityDropdownColor(value),
                          shape: BoxShape.circle, // Make it circular
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
                // Save the selected priority to shared preferences
                SharedPreferencesHelper.setSelectedPriority(_selectedPriority);
              },
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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

            if (tasks.isEmpty) {
              return const Center(
                child:
                    Text("No tasks added yet", style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                if (_selectedPriority == "all") {
                  return TaskListItem(task: task, userId: widget.userId);
                } else if (_selectedPriority == task.priority.name) {
                  return TaskListItem(task: task, userId: widget.userId);
                }
                return Container();
              },
            );
          } else {
            return Center(child: Text("No tasks available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task Screen using named route
          Navigator.pushNamed(context, '/addTask', arguments: widget.userId);
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
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

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final String userId;

  const TaskListItem({Key? key, required this.task, required this.userId})
      : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  // Function to get color based on priority
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return const Color.fromARGB(
            255, 192, 225, 193); // Green for low priority
      case Priority.medium:
        return const Color.fromRGBO(
            250, 230, 200, 1); // Orange for medium priority
      case Priority.high:
        return const Color.fromARGB(
            255, 255, 196, 192); // Red for high priority
      default:
        return Colors.grey; // Default color if unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final priorityColor =
        _getPriorityColor(task.priority); // Get color based on task's priority

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Smooth card edges
      ),
      elevation: 0, // No shadow to avoid blurred edges
      color: priorityColor, // Use solid color for the background
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle:
                Text('Due: ${task.dueDate}', style: TextStyle(fontSize: 14)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.lightBlue),
                  onPressed: () {
                    // Navigate to Edit Task Screen using named route
                    Navigator.pushNamed(
                      context,
                      '/editTask',
                      arguments: {'userId': widget.userId, 'task': task},
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Colors.red), // White color for the delete icon
                  onPressed: () {
                    BlocProvider.of<TaskBloc>(context).add(
                        DeleteTaskEvent(userId: widget.userId, task: task));
                  },
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          // Animated size for expanding/collapsing content
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Description: ${task.description}',
                              style: TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text('Priority: ${task.priority.name}',
                              style: TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text('Due Date: ${task.dueDate}',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(), // When collapsed, show nothing
          ),
        ],
      ),
    );
  }
}
