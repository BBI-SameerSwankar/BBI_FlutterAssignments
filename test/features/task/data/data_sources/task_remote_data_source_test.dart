import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/data/data_sources/task_remote_data_source.dart';

import 'package:task_app/features/task/domain/entity/task_model.dart';

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late TaskRemoteDataSourceImpl taskRemoteDataSource;
  late MockDatabaseReference mockDatabaseReference;
  late MockDataSnapshot mockDataSnapshot;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();
    taskRemoteDataSource = TaskRemoteDataSourceImpl();
    
    // Register fallbacks to ensure proper mocking behavior.
    registerFallbackValue(MockDatabaseReference());
    registerFallbackValue(MockDataSnapshot());
  });

  group('TaskRemoteDataSourceImpl', () {
    const userId = 'user123';
    final taskModel = TaskModel(
      id: 'task1',
      title: 'Test Task',
      description: 'This is a test task',
      dueDate: DateTime.now(),
      priority: Priority.medium,
    );

    test('should add a task successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.push()).thenReturn(taskRef);
      when(() => taskRef.set(any())).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.addTask(userId, taskModel);

      // Assert
      verify(() => taskRef.set(any())).called(1);
    });

    test('should delete a task successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.child(taskModel.id)).thenReturn(taskRef);
      when(() => taskRef.remove()).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.deleteTask(userId, taskModel);

      // Assert
      verify(() => taskRef.remove()).called(1);
    });

    test('should edit a task successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.child(taskModel.id)).thenReturn(taskRef);
      when(() => taskRef.update(any())).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.editTask(userId, taskModel);

      // Assert
      verify(() => taskRef.update(any())).called(1);
    });

    test('should fetch all tasks successfully', () async {
      // Arrange
      final taskMap = {
        'task1': {
          'title': taskModel.title,
          'description': taskModel.description,
          'dueDate': taskModel.dueDate.toIso8601String(),
          'priority': 'medium',
        },
      };
      when(() => mockDatabaseReference.child(userId).get()).thenAnswer(
        (_) async => mockDataSnapshot,
      );
      when(() => mockDataSnapshot.exists).thenReturn(true);
      when(() => mockDataSnapshot.value).thenReturn(taskMap);

      // Act
      final result = await taskRemoteDataSource.getAllTasks(userId);

      // Assert
      expect(result, isA<List<TaskModel>>());
      expect(result.length, 1);
      expect(result.first.id, taskModel.id);
      expect(result.first.title, taskModel.title);
    });

    test('should return an empty list if no tasks exist', () async {
      // Arrange
      when(() => mockDatabaseReference.child(userId).get()).thenAnswer(
        (_) async => mockDataSnapshot,
      );
      when(() => mockDataSnapshot.exists).thenReturn(false);
      when(() => mockDataSnapshot.value).thenReturn(null);

      // Act
      final result = await taskRemoteDataSource.getAllTasks(userId);

      // Assert
      expect(result, isA<List<TaskModel>>());
      expect(result.isEmpty, true);
    });

    test('should throw exception when adding a task fails', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.push()).thenReturn(taskRef);
      when(() => taskRef.set(any())).thenThrow(Exception('Failed to add task'));

      // Act & Assert
      expect(
        () => taskRemoteDataSource.addTask(userId, taskModel),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when deleting a task fails', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.child(taskModel.id)).thenReturn(taskRef);
      when(() => taskRef.remove()).thenThrow(Exception('Failed to delete task'));

      // Act & Assert
      expect(
        () => taskRemoteDataSource.deleteTask(userId, taskModel),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when editing a task fails', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(userId)).thenReturn(taskRef);
      when(() => taskRef.child(taskModel.id)).thenReturn(taskRef);
      when(() => taskRef.update(any())).thenThrow(Exception('Failed to edit task'));

      // Act & Assert
      expect(
        () => taskRemoteDataSource.editTask(userId, taskModel),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when fetching tasks fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(userId).get()).thenThrow(Exception('Failed to fetch tasks'));

      // Act & Assert
      expect(
        () => taskRemoteDataSource.getAllTasks(userId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
