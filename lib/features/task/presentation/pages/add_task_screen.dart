import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;

  const AddTaskScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  Priority _priority = Priority.low;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text('Due Date: ${_dueDate.toLocal()}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            DropdownButton<Priority>(
              value: _priority,
              onChanged: (Priority? newPriority) {
                setState(() {
                  _priority = newPriority!;
                });
              },
              items: Priority.values.map((Priority priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _addTask() {
    final newTask = TaskModel(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      priority: _priority,
    );

    BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(userId: widget.userId, task: newTask));
    Navigator.pop(context); // Close the screen
  }
}
