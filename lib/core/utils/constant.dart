

import 'package:flutter/material.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

class TaskScreenConstants{

    static const String noTasksAddedMessage = "No tasks added yet";
  static const String noTasksAvailableMessage = "No tasks available";
  static const String taskDeletedMessage = "Task deleted successfully";
  static const String taskTitleHint = "Enter task title";
  static const String taskDescriptionHint = "Enter task description";
  static const String taskDueDateLabel = "Due Date";
  static const String taskPriorityLabel = "Priority";
  static const String addTaskButtonLabel = "Add Task";
  static const String saveChangesButtonLabel = "Save Changes";
  static const String logoutDialogMessage = "Are you sure you want to log out?";
  static const String logoutDialogTitle = "Logout";
  static const String invalidPriorityMessage = "Invalid priority selection";
  static const String taskTitleLabel = "Title";
  static const String taskDescriptionLabel = "Description";
  static const String priorityLow = "low";
  static const String priorityMedium = "medium";
  static const String priorityHigh = "high";
  static const String priorityAll = "all";
  static const String selectPriorityMessage = "Please select a priority";




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