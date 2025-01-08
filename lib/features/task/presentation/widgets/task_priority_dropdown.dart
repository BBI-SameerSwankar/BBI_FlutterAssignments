import 'package:flutter/material.dart';
import 'package:task_app/core/utils/constant.dart';

class TaskPriorityDropdown extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String?> onPriorityChanged;

  const TaskPriorityDropdown({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: DropdownButton<String>(
        value: selectedPriority,
        dropdownColor: Colors.blueAccent,
        iconEnabledColor: Colors.white,
        style: TextStyle(color: Colors.white),
        underline: SizedBox(),
        items: ['all', 'low', 'medium', 'high'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: TaskScreenConstants.getPriorityDropdownColor(value), shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(value),
              ],
            ),
          );
        }).toList(),
        onChanged: onPriorityChanged,
      ),
    );
  }
}
