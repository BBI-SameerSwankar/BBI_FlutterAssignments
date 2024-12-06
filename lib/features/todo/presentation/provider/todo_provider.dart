import 'package:flutter/foundation.dart';
import 'package:todo_clean/features/todo/data/models/todo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean/core/error/failure.dart';
import 'package:todo_clean/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_clean/features/todo/domain/usecases/delete_todo_by_id.dart';
import 'package:todo_clean/features/todo/domain/usecases/edit_todo.dart';
import 'package:todo_clean/features/todo/domain/usecases/get_all_todos.dart';

class TodoProvider extends ChangeNotifier {
  final AddTodo addTodoUseCase;
  final DeleteTodo deleteTodoUseCase;
  final EditTodo editTodoUseCase;
  final GetAllTodos getAllTodosUseCase;

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider({
    required this.addTodoUseCase,
    required this.deleteTodoUseCase,
    required this.editTodoUseCase,
    required this.getAllTodosUseCase,
  }) {
    getAllTodos(); // Only call once on initial load
  }

  Future<void> addTodo(String title, String description) async {
  int newId = _todos.isEmpty ? 1 : _todos.last.id + 1;
  Todo todo = Todo(id: newId, title: title, description: description);

  final result = await addTodoUseCase.call(todo);
  result.fold(
    (l) => print("Error adding todo: ${l.toString()}"), // Handle error case
    (r) {
     
      _todos.add(todo); 
      print("addded success");
      print(_todos);
      // getAllTodos();
      notifyListeners(); 
    },
  );
}


  Future<void> deleteTodo(int id) async {
    final result = await deleteTodoUseCase.call(id);
    result.fold(
      (l) => print("Error deleting todo: ${l.toString()}"),
      (r) {
        _todos.removeWhere((todo) => todo.id == id);
        notifyListeners();
      },
    );
  }

  Future<void> editTodo(int id, String title, String description) async {
    Todo updatedTodo = Todo(id: id, title: title, description: description);

    final result = await editTodoUseCase.call(updatedTodo);
    result.fold(
      (l) => print("Error editing todo: ${l.toString()}"),
      (r) {
        int index = _todos.indexWhere((todo) => todo.id == id);
        if (index != -1) {
          _todos[index] = updatedTodo;
          notifyListeners();  // Notify listeners only once
        } else {
          print("Todo with ID $id not found.");
        }
      },
    );
  }

  Future<void> getAllTodos() async {
    final result = await getAllTodosUseCase.call();
    result.fold(
      (l) => print("Error fetching todos: ${l.toString()}"),
      (r) {
        _todos = r;
      print("getting todos in getall");
        notifyListeners();  // Notify listeners to refresh the UI
      },
    );
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    final result = await editTodoUseCase.call(updatedTodo);
 
    result.fold(
      (l) => print("Error updating todo: ${l.toString()}"),
      (r) {
        int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
        if (index != -1) {
          _todos[index] = updatedTodo;
           print(_todos);
          notifyListeners();  // Notify listeners
        } else {
          print("Todo with ID ${updatedTodo.id} not found.");
        }
      },
    );
  }
}
