// todo_state.dart

import 'package:task_app/features/task/domain/entity/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<TaskModel> tasks;

  TaskLoadedState({required this.tasks});
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}

