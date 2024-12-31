import 'package:firebase_database/firebase_database.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getAllTasks(String userId);
  Future<void> deleteTask(String userId, TaskModel task);
  Future<void> editTask(String userId, TaskModel task);
  Future<void> addTask(String userId, TaskModel task);
}

class TaskRemoteDataSourceImpl extends TaskRemoteDataSource {
  final DatabaseReference _taskRef = FirebaseDatabase.instance.ref('tasks');

  @override
  Future<void> addTask(String userId, TaskModel task) async {
    try {
      final taskRef = _taskRef.child(userId).push();
      await taskRef.set(task.toJson());
    } catch (e) {
      print("Error adding task: $e");
      throw Exception("Failed to add task");
    }
  }

  @override
  Future<void> deleteTask(String userId, TaskModel task) async {
    try {
      final taskRef = _taskRef.child(userId).child(task.id);
      await taskRef.remove();
    } catch (e) {
      print("Error deleting task: $e");
      throw Exception("Failed to delete task");
    }
  }

  @override
  Future<void> editTask(String userId, TaskModel task) async {
    try {
      final taskRef = _taskRef.child(userId).child(task.id);
      await taskRef.update(task.toJson());
    } catch (e) {
      print("Error editing task: $e");
      throw Exception("Failed to edit task");
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks(String userId) async {
    try {
      final snapshot = await _taskRef.child(userId).get();

      if (snapshot.exists) {

        final Map<dynamic, dynamic> tasksMap = snapshot.value as Map<dynamic, dynamic>;
      
       
        List<TaskModel> tasks = tasksMap.entries.map((entry) {
          return TaskModel.fromJson(entry.value, entry.key);
        }).toList();

        print("in remote....");
        
        print(tasks[0].id);

        return tasks;
      } else {
        return [];
      }
    } catch (e) {
      print("Error getting tasks: $e");
      throw Exception("Failed to fetch tasks");
    }
  }
} 
