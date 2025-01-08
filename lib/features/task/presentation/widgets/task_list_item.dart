import 'package:flutter/material.dart';
import 'package:task_app/core/utils/constant.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final String userId;
  final Function onEdit;
  final Function onDelete;

  const TaskListItem(
      {Key? key,
      required this.task,
      required this.userId,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  bool _isExpanded = false;

  void edit() {
    widget.onEdit();
  }

  void delete() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final priorityColor = TaskScreenConstants.getPriorityColor(task.priority);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: priorityColor,
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
                    onPressed: edit),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: delete),
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
                ? Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Text('Description: ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(
                                task.description == "" ? "-" : task.description,
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text('Priority:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(' ${task.priority.name}',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
