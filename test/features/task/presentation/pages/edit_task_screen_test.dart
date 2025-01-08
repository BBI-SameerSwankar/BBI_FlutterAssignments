import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/pages/edit_task_screen.dart';


class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  group('EditTaskScreen Tests', () {
    late MockTaskBloc mockTaskBloc;
    late TaskModel task;
    late String userId;

    setUp(() {
      mockTaskBloc = MockTaskBloc();
      task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Task Description',
        dueDate: DateTime(2023, 5, 1),
        priority: Priority.medium,
      );
      userId = 'user123';
    });

    testWidgets('displays form with current task data', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: EditTaskScreen(userId: userId, task: task),
          ),
        ),
      );

      // Verify initial values in the form fields
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Task Description'), findsOneWidget);
      expect(find.text('2023-05-01'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget); // Priority dropdown
    });

    testWidgets('validates form input and displays error if empty', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: EditTaskScreen(userId: userId, task: task),
          ),
        ),
      );

      // Find the form field and leave it empty
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      // Check for validation error
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('picks a new due date and updates UI', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: EditTaskScreen(userId: userId, task: task),
          ),
        ),
      );

      // Tap on the calendar icon to pick a new date
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // Select a new date, e.g., 2023-06-01
      // final datePicker = find.byType(DateTimePickerDialog);
      await tester.tap(find.text('2023-06-01'));
      await tester.pumpAndSettle();

      // Check if the new date is updated in the UI
      expect(find.text('2023-06-01'), findsOneWidget);
    });

    testWidgets('changes priority and updates UI', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: EditTaskScreen(userId: userId, task: task),
          ),
        ),
      );

      // Tap to open priority dropdown and select a new priority
      await tester.tap(find.byType(DropdownButton<Priority>));
      await tester.pumpAndSettle();

      // Select 'High' priority
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      // Check if the priority is updated
      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('saves changes and triggers EditTaskEvent', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (_) => mockTaskBloc,
            child: EditTaskScreen(userId: userId, task: task),
          ),
        ),
      );

      // Tap the Save Changes button
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      // Verify if EditTaskEvent was added to the bloc
      verify(() => mockTaskBloc.add(EditTaskEvent(userId: userId, task: task.copyWith(
        title: 'Test Task',
        description: 'Test Task Description',
        dueDate: DateTime(2023, 6, 1),
        priority: Priority.high,
      )))).called(1);
    });
  });
}
