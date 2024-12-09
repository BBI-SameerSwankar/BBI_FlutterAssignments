import 'package:fpdart/fpdart.dart';

import 'package:todo_bloc_app/core/error/failure.dart';
import 'package:todo_bloc_app/features/todo/data/models/todo.dart';

import 'package:todo_bloc_app/features/todo/domain/respository/todo_respositories.dart';

class GetAllTodos {

  final TodoRepository repository;

  GetAllTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() {
    return repository.getAllTodos();
  }

}