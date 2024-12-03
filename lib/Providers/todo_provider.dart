import 'package:flutter/foundation.dart';

class TodoProvider extends ChangeNotifier {

  List<List<String>> data = [
    ["Title", "asdfasdf"]
  ];

 
  void addTodo(String title, String description) {
    data.add([title, description]);
    notifyListeners();
  }


  void deleteTodo(int id) {
    if (id >= 0 && id < data.length) {
      data.removeAt(id);
      notifyListeners();
    } else {
  
      print("Invalid ID: $id");
    }
  }


  void editTodo(int id, String title, String description) {
    if (id >= 0 && id < data.length) {
      data[id] = [title, description];
      notifyListeners();
    } else {
 
      print("Invalid ID: $id");
    }
  }
}
