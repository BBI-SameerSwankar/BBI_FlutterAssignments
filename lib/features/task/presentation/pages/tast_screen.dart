import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/utils/shared_preference_helper.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';
import 'package:task_app/features/task/presentation/widgets/task_list_item.dart'; // Import SharedPreferences helper

class TaskScreen extends StatefulWidget {
  final String userId;

  const TaskScreen({super.key, required this.userId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _isAscending = true;
  String _selectedPriority = 'all';
  bool isEmptyTaskList = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(ClearAllTasks());
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
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getPriorityDropdownColor(value),
                          shape: BoxShape.circle, 
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                isEmptyTaskList = true;
                setState(() {
                  _selectedPriority = newValue!;
                });
        
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
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  if (isEmptyTaskList) {
                    return Container(
                       height: MediaQuery.of(context).size.height*0.8,
                      alignment: Alignment.center,
                      child:   Text("No tasks added yet", style: TextStyle(fontSize: 18)),
     
                      
                      
                      );
                  }
                  return Container();
                }
                final task = tasks[index];

                if (_selectedPriority == "all" ||
                    (_selectedPriority == task.priority.name)) {
                  isEmptyTaskList = false;
                  return TaskListItem(task: task, userId: widget.userId);
                }
                return Container();
              },
            );
          } else {
            return const Center(child: Text("No tasks available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTask', arguments: widget.userId)
              .then((_) {
            BlocProvider.of<TaskBloc>(context)
                .add(FetchTasksEvent(id: widget.userId));
          });
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
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
                BlocProvider.of<TaskBloc>(context).add(ClearAllTasks());
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
