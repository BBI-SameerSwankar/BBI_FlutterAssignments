import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_bloc_app/features/todo/domain/usecases/edit_todo.dart';
import 'package:todo_bloc_app/features/todo/domain/usecases/delete_todo_by_id.dart';
import 'package:todo_bloc_app/features/todo/domain/usecases/get_all_todos.dart';
import 'package:todo_bloc_app/features/todo/data/models/todo.dart';
import 'package:todo_bloc_app/core/error/failure.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_bloc_app/features/todo/presentation/bloc/todo_state.dart';



class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTodo addTodoUseCase;
  final DeleteTodo deleteTodoUseCase;
  final EditTodo editTodoUseCase;
  final GetAllTodos getAllTodosUseCase;

  List<Todo> _todos = [];

  TodoBloc({
    required this.addTodoUseCase,
    required this.deleteTodoUseCase,
    required this.editTodoUseCase,
    required this.getAllTodosUseCase,
  }) : super(TodoInitial()) {
    on<TodoLoaded>(_onTodoLoaded);
    on<AddTodoEvent>(_onAddTodo);
    on<EditTodoEvent>(_onEditTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onTodoLoaded(TodoLoaded event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await getAllTodosUseCase.call();

    result.fold(
      (failure) => emit(TodoError(message: failure.toString())),
      (todos) {
        _todos = todos;
        emit(TodoLoadedState(todos: todos));
      },
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    int newId = _todos.isEmpty ? 1 : _todos.last.id + 1;
    Todo todo = Todo(id: newId, title: event.title, description: event.description);

    final result = await addTodoUseCase.call(todo);

    result.fold(
      (failure) => emit(TodoOperationFailure(message: failure.toString())),
      (success) {
        _todos.add(todo);
        emit(TodoOperationSuccess(todos: _todos));
      },
    );
  }

  Future<void> _onEditTodo(EditTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    Todo updatedTodo = Todo(id: event.id, title: event.title, description: event.description);

    final result = await editTodoUseCase.call(updatedTodo);

    result.fold(
      (failure) => emit(TodoOperationFailure(message: failure.toString())),
      (success) {
        int index = _todos.indexWhere((todo) => todo.id == event.id);
        if (index != -1) {
          _todos[index] = updatedTodo;
          emit(TodoOperationSuccess(todos: _todos));
        } else {
          emit(TodoOperationFailure(message: "Todo not found"));
        }
      },
    );
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await deleteTodoUseCase.call(event.id);

    result.fold(
      (failure) => emit(TodoOperationFailure(message: failure.toString())),
      (success) {
        _todos.removeWhere((todo) => todo.id == event.id);
        emit(TodoOperationSuccess(todos: _todos));
      },
    );
  }
}
