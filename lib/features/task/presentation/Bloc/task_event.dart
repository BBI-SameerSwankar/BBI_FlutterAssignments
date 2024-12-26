
abstract class TaskEvent {}

class TaskLoaded extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;

  AddTaskEvent({required this.title, required this.description});
}

class EditTaskEvent extends TaskEvent {
  final int id;
  final String title;
  final String description;

  EditTaskEvent({
    required this.id,
    required this.title,
    required this.description,
  });
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  DeleteTaskEvent({required this.id});
}
