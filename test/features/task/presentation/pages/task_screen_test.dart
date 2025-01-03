import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';

import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/presentation/pages/add_task_screen.dart';
import 'package:task_app/features/task/presentation/pages/tast_screen.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  group('TaskScreen', () {
    late MockTaskBloc taskBloc;
    late MockAuthBloc authBloc;

    setUp(() {
      taskBloc = MockTaskBloc();
      authBloc = MockAuthBloc();
    });

    testWidgets('renders loading indicator when tasks are loading', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoading());

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Verify the loading indicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when tasks have an error', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskError(message: 'Something went wrong'));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Verify the error message is shown
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('displays no tasks message when task list is empty', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoadedState(tasks: []));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Verify the no tasks message is shown
      expect(find.text('No tasks added yet'), findsOneWidget);
    });

    testWidgets('displays task list when tasks are loaded', (tester) async {
      // Mock some tasks data
      final tasks = [
        TaskModel(id: '1', title: 'Test Task', description: 'Description', priority: Priority.low, dueDate: DateTime.now()),
        TaskModel(id: '2', title: 'Second Task', description: 'Description', priority: Priority.medium, dueDate: DateTime.now()),
      ];

      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoadedState(tasks: tasks));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Verify the task list is displayed
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });

    testWidgets('navigates to add task screen on floating action button press', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoadedState(tasks: []));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Tap the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify the add task screen is pushed
      expect(find.byType(AddTaskScreen), findsOneWidget);
    });

    testWidgets('shows logout dialog when logout button is pressed', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoadedState(tasks: []));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<TaskBloc>.value(
          value: taskBloc,
          child: MaterialApp(
            home: TaskScreen(userId: 'testUser'),
          ),
        ),
      );

      // Tap the logout button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Verify the logout dialog is displayed
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
    });

    testWidgets('logs out when logout button is pressed in the dialog', (tester) async {
      // Mock the state
      when(() => taskBloc.state).thenReturn(TaskLoadedState(tasks: []));

      // Build the widget
      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: BlocProvider<TaskBloc>.value(
            value: taskBloc,
            child: MaterialApp(
              home: TaskScreen(userId: 'testUser'),
            ),
          ),
        ),
      );

  
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Tap the logout confirmation button
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Verify that logout event was dispatched
      verify(() => authBloc.add(LogoutUserEvent())).called(1);
    });
  });
}
