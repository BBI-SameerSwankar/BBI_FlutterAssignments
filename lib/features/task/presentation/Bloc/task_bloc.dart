
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/usecases/add_task.dart';
import 'package:task_app/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_app/features/task/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/task/domain/usecases/get_all_tasks_usecase.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';

// task_bloc.dart
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTaskUsecase fetchTasks;
  final AddTaskUsecase addTask;
  final EditTaskUsecase editTask;
  final DeleteTaskUsecase deleteTask;

  List<TaskModel> _sortedTasks = [];
  bool _ascending = true;

  TaskBloc({
    required this.fetchTasks,
    required this.addTask,
    required this.editTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<FetchTasksEvent>(_onFetchTasks);
    on<AddTaskEvent>(_onAddTask);
    on<EditTaskEvent>(_onEditTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasksEvent>(_onFilterTasks); 
    on<ClearAllTasks>(_clearAllTasks); 
 // New event handler for filtering
  }

  // Sort tasks by due date
 List<TaskModel> _sortTasksByDueDate(List<TaskModel> tasks, {bool ascending = true}) {
  tasks.sort((a, b) {
    // First compare by dueDate
    final dueDateComparison = a.dueDate.compareTo(b.dueDate);

    if (dueDateComparison != 0) {
      // If due dates are different, return the result based on dueDate comparison
      return ascending ? dueDateComparison : -dueDateComparison;
    } else {
      // If due dates are the same, compare by title alphabetically
      final titleComparison = a.title.compareTo(b.title);
      return ascending ? titleComparison : -titleComparison;
    }
  });

  return tasks;
}


  // Handle fetching tasks
  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {

    emit(TaskLoading());
    final res = await fetchTasks.call(event.id);
    res.fold(
      (l) {
        emit(TaskError(message: l.message));
      },
      (r) {
        _sortedTasks = _sortTasksByDueDate(r,ascending: _ascending);  // Default to ascending order
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle adding a task
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final res = await addTask.call(event.userId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks.add(event.task);
        _sortedTasks = _sortTasksByDueDate(_sortedTasks); // Sort after adding
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle editing a task
  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    print("thios  is in blloc");
    print(event.userId);
    final res = await editTask.call(event.userId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks = _sortedTasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);  // Resort after editingev
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle deleting a task
  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    print("deleting....");
    print(event.userId);
    print(event.task.id);
     emit(TaskLoading());
    final res = await deleteTask.call(event.userId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks.removeWhere((task) => task.id == event.task.id);
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle filtering tasks by due date order (ascending or descending)
  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    print(event.ascending);
    _ascending = event.ascending;
    _sortedTasks = _sortTasksByDueDate(_sortedTasks, ascending: event.ascending);
    emit(TaskLoadedState(tasks: _sortedTasks));
  }

  void _clearAllTasks(ClearAllTasks event, Emitter<TaskState> emit)
  {
    _sortedTasks.clear();
    // emit(TaskLoadedState(tasks: []));
  }
}
