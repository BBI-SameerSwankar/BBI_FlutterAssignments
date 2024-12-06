import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_clean/features/todo/data/models/todo.dart';

abstract class TodoLocalDataSource {
  Future<List<Todo>> getTodos();
  Future<void> saveTodo(Todo todo);
  Future<void> deleteTodo(int index);
  Future<void> updateTodo(Todo todo);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  static const String _todoKey = 'todos';
  static const String _todoIdCounterKey = 'todoIdCounter';

  List<Todo> _getTodosFromPrefs() {
    final String? todosJson = sharedPreferences.getString(_todoKey);
    if (todosJson != null) {
      List<dynamic> jsonList = json.decode(todosJson);
      return jsonList.map((jsonItem) => Todo.fromJson(jsonItem)).toList();
    }
    return [];
  }

  Future<void> _saveTodosToPrefs(List<Todo> todos) async {

   

    final List<Map<String, dynamic>> jsonList =
        todos.map((todo) => todo.toJson()).toList();
    final String todosJson = json.encode(jsonList);
    await sharedPreferences.setString(_todoKey, todosJson);
  }

  int _getCurrentIdCounter() {
    return sharedPreferences.getInt(_todoIdCounterKey) ?? 0;
  }

  Future<void> _incrementIdCounter() async {
    final currentId = _getCurrentIdCounter();
    await sharedPreferences.setInt(_todoIdCounterKey, currentId + 1);
  }

  @override
  Future<List<Todo>> getTodos() async {
    return _getTodosFromPrefs();
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    List<Todo> todos = _getTodosFromPrefs();

    
    final newId = _getCurrentIdCounter();


    final newTodo = Todo(
      id: newId,
      title: todo.title,
      description: todo.description,
    );

 
    todos.add(newTodo);

 
    await _saveTodosToPrefs(todos);

    await _incrementIdCounter();
  }

  @override
  Future<void> deleteTodo(int index) async {
    List<Todo> todos = _getTodosFromPrefs();
    if (index >= 0 && index < todos.length) {
      // Remove the todo at the given index
      todos.removeAt(index);

      // Save the updated list back to SharedPreferences
      await _saveTodosToPrefs(todos);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    List<Todo> todos = _getTodosFromPrefs();

    // Find the index of the todo with the given ID
    final index = todos.indexWhere((t) => t.id == todo.id);

    if (index != -1) {
      // Update the todo at the found index
      todos[index] = todo.copyWith(
        title: todo.title,
        description: todo.description,
      );

      // Save the updated list back to SharedPreferences
      await _saveTodosToPrefs(todos);
    } else {
      throw Exception("Todo not found");
    }
  }
}
