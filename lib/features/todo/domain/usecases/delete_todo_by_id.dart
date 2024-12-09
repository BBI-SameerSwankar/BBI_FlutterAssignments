import 'package:fpdart/fpdart.dart';

import 'package:todo_bloc_app/core/error/failure.dart';
import 'package:todo_bloc_app/features/todo/data/models/todo.dart';
import 'package:todo_bloc_app/features/todo/domain/respository/todo_respositories.dart';

class DeleteTodo {

  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteTodoById(id: id);
  }

}