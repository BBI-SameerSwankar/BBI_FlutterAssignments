import 'package:todo_clean/core/error/failure.dart';
import 'package:todo_clean/features/todo/data/data_sources/todo_local_data_source.dart';
import 'package:todo_clean/features/todo/data/models/todo.dart';
import 'package:todo_clean/features/todo/domain/respository/todo_respositories.dart';
import 'package:fpdart/fpdart.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource todoLocalDataSource;

  TodoRepositoryImpl({required this.todoLocalDataSource});

  @override
  Future<Either<Failure, void>> addTodo({
    required Todo todo,
  }) async {


    try {
      await todoLocalDataSource.saveTodo(todo);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editTodo({
    required Todo todoInp,
  }) async {
    try {
      final todos = await todoLocalDataSource.getTodos();

      // Find the index of the todo with the given ID
      final index = todos.indexWhere((todo) => todo.id == todoInp.id);

      if (index != -1) {
        // Update the todo if it's found
        await todoLocalDataSource.updateTodo(todoInp);
        return const Right(null);
      } else {
        return Left(Failure('Todo not found'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try {
      final todos = await todoLocalDataSource.getTodos();
      return Right(todos);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodoById({
    required int id, 
  }) async {
    try {
      final todos = await todoLocalDataSource.getTodos();
      final index = todos.indexWhere((todo) => todo.id == id);

      if (index != -1) {
        await todoLocalDataSource.deleteTodo(index);
        return const Right(null);
      } else {
        return Left(Failure('Todo not found'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
