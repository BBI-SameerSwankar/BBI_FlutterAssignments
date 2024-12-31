import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title TextField
            _buildTextField(
              controller: _titleController,
              labelText: 'Title',
              hintText: 'Enter task title',
            ),
            const SizedBox(height: 16),

            // Description TextField
            _buildTextField(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Enter task description',
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Due Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Due Date: ${_dueDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Priority Dropdown
            _buildPriorityDropdown(),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _editTask,
              style: ElevatedButton.styleFrom(
                // primary: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  // Helper method to build priority dropdown
  Widget _buildPriorityDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Priority>(
          value: _priority,
          onChanged: (Priority? newPriority) {
            setState(() {
              _priority = newPriority!;
            });
          },
          isExpanded: true,
          items: Priority.values.map((Priority priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(
                priority.toString().split('.').last.capitalizeFirstLetter(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper method to pick date
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

  // Method to handle editing task
  void _editTask() {
    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      priority: _priority,
    );

    BlocProvider.of<TaskBloc>(context).add(EditTaskEvent(userId: widget.task.id, task: updatedTask));
    Navigator.pop(context); // Close the screen
  }
}

// Extension to capitalize first letter of a string
extension StringCasingExtension on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
