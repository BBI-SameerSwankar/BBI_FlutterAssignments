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

class TaskOperationSuccess extends TaskState {
  final List<TaskModel> tasks;

  TaskOperationSuccess({required this.tasks});
}

class TaskOperationFailure extends TaskState {
  final String message;

  TaskOperationFailure({required this.message});
}

