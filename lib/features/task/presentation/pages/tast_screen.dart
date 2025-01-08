import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/utils/constant.dart';
import 'package:task_app/core/utils/shared_preference_helper.dart';
import 'package:task_app/core/utils/theme.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';
import 'package:task_app/features/task/presentation/widgets/task_list_item.dart';
import 'package:task_app/features/task/presentation/widgets/logout_dialog.dart';


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
    isEmptyTaskList = true;
    BlocProvider.of<TaskBloc>(context).add(ClearAllTasks());
    _loadPreferences();
    BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: widget.userId));
  }

  // Load the preferences for sorting and priority filter
  void _loadPreferences() async {
    final isAscending = await SharedPreferencesHelper.getIsAscending();
    final selectedPriority = await SharedPreferencesHelper.getSelectedPriority();
    setState(() {
      _isAscending = isAscending;
      _selectedPriority = selectedPriority;
    });
  }

  void onDelete(TaskModel task) {
    BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(userId: widget.userId, task: task));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks for ${widget.userId}", style: AppTheme.appBarTextStyle),
        backgroundColor: AppTheme.primaryColor, // Use the primary color from the theme
        actions: [
          IconButton(
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: AppTheme.secondaryColor, // Use the secondary color from the theme
            ),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
              SharedPreferencesHelper.setIsAscending(_isAscending);
              BlocProvider.of<TaskBloc>(context).add(FilterTasksEvent(ascending: _isAscending));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedPriority,
              dropdownColor: AppTheme.primaryColor, // Use primary color for the dropdown
              iconEnabledColor: AppTheme.secondaryColor, // Use the secondary color for icon
              style: TextStyle(color: AppTheme.secondaryColor), // Use the secondary color for text
              underline: SizedBox(),
              items: ['all', 'low', 'medium', 'high'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: TaskScreenConstants.getPriorityDropdownColor(value),
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
          // Logout button - Use the LogoutDialog widget for logout functionality
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.secondaryColor),
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
              return const Center(child: Text("No tasks added yet", style: TextStyle(fontSize: 18)));
            }

            return ListView.builder(
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  if (isEmptyTaskList) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      alignment: Alignment.center,
                      child: const Text("No tasks added yet", style: TextStyle(fontSize: 18)),
                    );
                  }
                  return Container();
                }
                final task = tasks[index];

                if (_selectedPriority == "all" || (_selectedPriority == task.priority.name)) {
                  isEmptyTaskList = false;
                  return TaskListItem(
                    task: task,
                    userId: widget.userId,
                    onEdit: () {
                      // Navigate to Edit Task Screen using named route
                      Navigator.pushNamed(
                        context,
                        '/editTask',
                        arguments: {'userId': widget.userId, 'task': task},
                      ).then((_) {
                        isEmptyTaskList = true;
                        BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: widget.userId));
                      });
                    },
                    onDelete: () {
                      BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(userId: widget.userId, task: task));
                    },
                  );
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
          Navigator.pushNamed(context, '/addTask', arguments: widget.userId).then((_) {
            BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: widget.userId));
          });
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: AppTheme.secondaryColor),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }
}
