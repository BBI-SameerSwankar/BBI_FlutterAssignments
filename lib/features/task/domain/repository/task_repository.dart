




import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';


abstract class TaskRepository {

  Future<Either<Failure,List<TaskModel> >> getAllTasks(String userId);
  Future<Either<Failure,void >> deleteTask(String userId, TaskModel task);
  Future<Either<Failure,void >> editTask(String userId, TaskModel task);
  Future<Either<Failure,void >> addTask(String userId, TaskModel task);

} 

