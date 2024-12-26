

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';

class GetAllTaskUsecase {

  final TaskRepository repository;
  GetAllTaskUsecase(this.repository);

  Future<Either<Failure ,void >> call( String userId)
  {
    return repository.getAllTasks(userId);
  }

}