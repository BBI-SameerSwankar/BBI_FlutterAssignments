import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/presentation/Bloc/task_bloc.dart';
import 'package:task_app/features/task/presentation/Bloc/task_event.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/presentation/Bloc/task_state.dart';
import 'package:task_app/features/task/presentation/pages/add_task_screen.dart';

// Mock class for TaskBloc
class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}
class MockTaskEvent extends Mock implements AddTaskEvent{}

void main() {
  group('AddTaskScreen', () {
    late MockTaskBloc mockTaskBloc;

    setUp(() {
      mockTaskBloc = MockTaskBloc();
    });

    testWidgets('renders AddTaskScreen correctly', (WidgetTester tester) async {
      // Arrange: build the widget tree with mock TaskBloc provider
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (context) => mockTaskBloc,
            child: AddTaskScreen(userId: 'test_user_id'),
          ),
        ),
      );

      // Assert: Check if the UI elements exist
      expect(find.text('Add Task'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Priority'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
    });

    testWidgets('displays error when title is empty and Add Task is pressed', (WidgetTester tester) async {
      // Arrange: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (context) => mockTaskBloc,
            child: AddTaskScreen(userId: 'test_user_id'),
          ),
        ),
      );

      // Simulate pressing the Add Task button without filling out the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert: Check if validation error for the title is displayed
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('can add task with valid input', (WidgetTester tester) async {
      // Arrange: Initialize the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (context) => mockTaskBloc,
            child: AddTaskScreen(userId: 'test_user_id'),
          ),
        ),
      );

      // Act: Fill out the form with valid input
      await tester.enterText(find.byType(TextFormField).at(0), 'New Task Title');
      await tester.enterText(find.byType(TextFormField).at(1), 'Task description');
      await tester.tap(find.byType(DropdownButtonHideUnderline));
      await tester.pumpAndSettle(); // Wait for dropdown to open and close
      await tester.tap(find.text('High').last); // Choose High priority
      await tester.pump();

      // Set up the mock to handle add call
      when(() => mockTaskBloc.add(AddTaskEvent(
          userId: 'test_user_id',
          task: TaskModel(
            id: "asdfsdf", // Mock or match this to the value your code uses
            title: 'New Task Title',
            description: 'Task description',
            dueDate: DateTime.now(), // Use `any` to allow for DateTime flexibility
            priority: Priority.high,
          ),
        ),
      )).thenAnswer((_) async {});

      // Act: Press the Add Task button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert: Verify that the correct event was triggered with the right parameters
      verify(() => mockTaskBloc.add(
        AddTaskEvent(
          userId: 'test_user_id',
          task: TaskModel(
            id: "asdfsdf", // Mock or match this to the value your code uses
            title: 'New Task Title',
            description: 'Task description',
            dueDate: DateTime.now(), // Use `any` to allow for DateTime flexibility
            priority: Priority.high,
          ),
        ),
      )).called(1);
    });

    testWidgets('picks a due date when the calendar icon is tapped', (WidgetTester tester) async {
      // Arrange: Initialize the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>(
            create: (context) => mockTaskBloc,
            child: AddTaskScreen(userId: 'test_user_id'),
          ),
        ),
      );

      // Act: Open the calendar picker
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // Assert: Verify the date picker is displayed
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
