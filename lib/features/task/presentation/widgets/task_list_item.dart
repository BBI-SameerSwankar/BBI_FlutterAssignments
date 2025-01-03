
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';

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
                    ).then(
                      (_)
                      {
                         BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(id: widget.userId));
                      }
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Colors.red), // White color for the delete icon
                  onPressed: () {
                    BlocProvider.of<TaskBloc>(context).add(
                    
                        DeleteTaskEvent(userId: widget.userId, task: task));
                         setState(() {});
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
                        // ListTile(
                        //   title: Text('Due Date: ${task.dueDate}',
                        //       style: TextStyle(fontSize: 14)),
                        // ),
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
