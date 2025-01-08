

import 'package:flutter/material.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

class TaskScreenConstants{
    static Color getPriorityDropdownColor(String priority) {
    switch (priority) {
      case 'low':
        return const Color.fromARGB(255, 192, 225, 193); // Green for low priority
      case 'medium':
        return const Color.fromRGBO(250, 230, 200, 1); // Orange for medium priority
      case 'high':
        return const Color.fromARGB(255, 255, 196, 192); // Red for high priority
      default:
        return Colors.grey; // Default color if unknown
    }
  } 

  static getPriorityColor(Priority priority) {
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


}