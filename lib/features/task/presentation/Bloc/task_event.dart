
import 'package:task_app/features/task/domain/entity/task_model.dart';

abstract class TaskEvent {}



class AddTaskEvent extends TaskEvent {
  final TaskModel task;
  final String userId;

  AddTaskEvent({required this.task, required this.userId});
}

class EditTaskEvent extends TaskEvent {
  final TaskModel task;
  final String userId;

  EditTaskEvent({
    required this.userId,
    required this.task
  });
}

class DeleteTaskEvent extends TaskEvent {
  final TaskModel task;
  final String userId;

  DeleteTaskEvent({
    required this.userId,
    required this.task
  });
}

class FetchTasksEvent extends TaskEvent {

  final String id;

  FetchTasksEvent({required this.id});
}
