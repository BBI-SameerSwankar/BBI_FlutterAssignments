import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/domain/usecases/add_task.dart';
import 'package:test/test.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';


// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late AddTaskUsecase addTaskUsecase;

  // Test setup
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    addTaskUsecase = AddTaskUsecase(mockTaskRepository);
  });

  group('AddTaskUsecase', () {
    final String userId = 'user123';
    final TaskModel task = TaskModel(
      id: 'task123',
      title: 'Test Task',
      description: 'This is a test task.',
      dueDate: DateTime.now(),
      priority: Priority.medium,
    );

    test('should call addTask method on repository with correct parameters', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(userId, task)).thenAnswer((_) async => Right(null));

      // Act
      await addTaskUsecase(userId, task);

      // Assert
      verify(() => mockTaskRepository.addTask(userId, task)).called(1);
    });

    test('should return a Failure when the repository fails', () async {
      // Arrange
      final failure = Failure('Error adding task');
      when(() => mockTaskRepository.addTask(userId, task))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addTaskUsecase(userId, task);

      // Assert
      expect(result, Left(failure));
    });

    test('should return a success response when the task is added successfully', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(userId, task)).thenAnswer((_) async => Right(null));

      // Act
      final result = await addTaskUsecase(userId, task);

      // Assert
      expect(result, Right(null));
    });
  });
}
