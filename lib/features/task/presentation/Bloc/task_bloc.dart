
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/usecases/add_task.dart';
import 'package:task_app/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_app/features/task/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/task/domain/usecases/get_all_tasks_usecase.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTaskUsecase fetchTasks;
  final AddTaskUsecase addTask;
  final EditTaskUsecase editTask;
  final DeleteTaskUsecase deleteTask;

  List<TaskModel> _sortedTasks = [];

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
  }

  // Sort tasks by due date
  List<TaskModel> _sortTasksByDueDate(List<TaskModel> tasks) {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return tasks;
  }

  // Handle fetching tasks
  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
      
    emit(TaskLoading());
    final res = await fetchTasks.call(event.id);
    res.fold(
      (l){
        emit(TaskError(message: l.message));
      },
      (r) {
        _sortedTasks = _sortTasksByDueDate(r);
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle adding a task
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    print(_sortedTasks);
    // emit(TaskLoading());
    final res = await addTask.call(event.userId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Add the new task to the sorted list
        _sortedTasks.add(event.task);
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle editing a task
  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await editTask.call(event.userId,  event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Update the task and resort the list
        _sortedTasks = _sortedTasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList(); 
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }

  // Handle deleting a task
  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    // emit(TaskLoading());
  

    final res = await deleteTask.call(event.userId , event.task);
    print(res);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Remove the task from the sorted list
        _sortedTasks.removeWhere((task) => task.id == event.task.id);
        emit(TaskLoadedState(tasks: _sortedTasks));
      },
    );
  }
}