// todo_event.dart


abstract class TodoEvent {}

class TodoLoaded extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;

  AddTodoEvent({required this.title, required this.description});
}

class EditTodoEvent extends TodoEvent {
  final int id;
  final String title;
  final String description;

  EditTodoEvent({
    required this.id,
    required this.title,
    required this.description,
  });
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  DeleteTodoEvent({required this.id});
}
