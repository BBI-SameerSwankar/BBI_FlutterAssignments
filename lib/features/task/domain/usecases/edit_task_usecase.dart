

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';

class EditTaskUsecase {
  final TaskRepository repository;
  EditTaskUsecase(this.repository);

  Future<Either<Failure ,void >> call( String userId, TaskModel task)
  {
    return repository.editTask(userId, task);
  }

}