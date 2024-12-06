import 'package:fpdart/fpdart.dart';

import 'package:todo_clean/core/error/failure.dart';
import 'package:todo_clean/features/todo/data/models/todo.dart';
import 'package:todo_clean/features/todo/domain/respository/todo_respositories.dart';

class AddTodo {

  final TodoRepository repository;

  AddTodo(this.repository);

  Future<Either<Failure, void>> call(Todo todo) {
    return repository.addTodo(todo: todo);
  }

}