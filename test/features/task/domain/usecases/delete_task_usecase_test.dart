


import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';
import 'package:task_app/features/task/domain/usecases/delete_task_usecase.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late DeleteTaskUsecase deleteTaskUsecase;

  // Test setup
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTaskUsecase = DeleteTaskUsecase(mockTaskRepository);
  });

  group('DeleteTaskUsecase', () {
    final String userId = 'user123';
    final TaskModel task = TaskModel(
      id: 'task123',
      title: 'Test Task',
      description: 'This is a test task.',
      dueDate: DateTime.now(),
      priority: Priority.medium,
    );

    test('should call deleteTask method on repository with correct parameters', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(userId, task)).thenAnswer((_) async => Right(null));

      // Act
      await deleteTaskUsecase(userId, task);

      // Assert
      verify(() => mockTaskRepository.deleteTask(userId, task)).called(1);
    });

    test('should return a Failure when the repository fails', () async {
      // Arrange
      final failure = Failure('Error deleting task');
      when(() => mockTaskRepository.deleteTask(userId, task))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteTaskUsecase(userId, task);

      // Assert
      expect(result, Left(failure));
    });

    test('should return a success response when the task is deleted successfully', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(userId, task)).thenAnswer((_) async => Right(null));

      // Act
      final result = await deleteTaskUsecase(userId, task);

      // Assert
      expect(result, Right(null));
    });
  });
}
