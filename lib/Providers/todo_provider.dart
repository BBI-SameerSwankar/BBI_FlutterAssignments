import 'package:flutter/foundation.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(id: 1, title: "Title", description: "asdfasdf"), 
  ];

  List<Todo> get todos => _todos;


  void addTodo(String title, String description) {
    int newId = _todos.isEmpty ? 1 : _todos.last.id + 1; 
    _todos.add(Todo(id: newId, title: title, description: description));
    notifyListeners();
  }

 
  void deleteTodo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  
  void editTodo(int id, String title, String description) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = Todo(id: id, title: title, description: description);
      notifyListeners();
    } else {
      print("Todo with ID $id not found.");
    }
  }


  void updateTodo(Todo updatedTodo) {
    int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    } else {
      print("Todo with ID ${updatedTodo.id} not found.");
    }
  }
}
