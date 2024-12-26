

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';

class AddTaskUsecase {
  final TaskRepository repository;
  AddTaskUsecase(this.repository);

  Future<Either<Failure ,void >> call( String userId, TaskModel task)
  {
    return repository.addTask(userId, task);
  }

}