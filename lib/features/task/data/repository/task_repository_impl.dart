import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/data/data_sources/task_remote_data_source.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';

abstract class TaskRepositoryImpl extends TaskRepository {
  final TaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImpl(this.taskRemoteDataSource);


  @override
  Future<Either<Failure, List<TaskModel>>> getAllTasks(String userId) async {
    try {
      final tasks = await taskRemoteDataSource.getAllTasks(userId);
      return Right(tasks);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(
      String userId, TaskModel task) async {
    try {
      await taskRemoteDataSource.deleteTask(userId, task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editTask(String userId, TaskModel task) async {
    try {
      await taskRemoteDataSource.editTask(userId, task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(String userId, TaskModel task) async {
    try {
      await taskRemoteDataSource.addTask(userId, task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
