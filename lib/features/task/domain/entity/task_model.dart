enum Priority {
  low,
  medium,
  high,
}


class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;  

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });

  // Factory method to create a TaskModel from a map.
  factory TaskModel.fromJson(Map<dynamic, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: _priorityFromString(map['priority']),
    );
  }

  // Convert enum to string for storage in Firestore or other databases
  static String _priorityToString(Priority priority) {
    return priority.toString().split('.').last;
  }

  // Convert string to enum for reading from Firestore or other databases
  static Priority _priorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        throw ArgumentError('Invalid priority value');
    }
  }

  // Method to convert TaskModel to map, for saving in Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': _priorityToString(priority),
    };
  }

  // Copy method to create a modified copy of TaskModel
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}        