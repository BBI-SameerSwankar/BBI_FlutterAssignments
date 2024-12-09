// todo_state.dart

import 'package:todo_bloc_app/features/todo/data/models/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoadedState extends TodoState {
  final List<Todo> todos;

  TodoLoadedState({required this.todos});
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}

class TodoOperationSuccess extends TodoState {
  final List<Todo> todos;

  TodoOperationSuccess({required this.todos});
}

class TodoOperationFailure extends TodoState {
  final String message;

  TodoOperationFailure({required this.message});
}

