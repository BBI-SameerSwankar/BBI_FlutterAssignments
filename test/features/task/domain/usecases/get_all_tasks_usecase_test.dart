import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/task/domain/usecases/get_all_tasks_usecase.dart';
import 'package:test/test.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/task/domain/entity/task_model.dart';
import 'package:task_app/features/task/domain/repository/task_repository.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late GetAllTaskUsecase getAllTaskUsecase;

  // Test setup
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getAllTaskUsecase = GetAllTaskUsecase(mockTaskRepository);
  });

  group('GetAllTaskUsecase', () {
    final String userId = 'user123';
    final List<TaskModel> tasks = [
      TaskModel(
        id: 'task1',
        title: 'Task 1',
        description: 'This is task 1',
        dueDate: DateTime.now().add(Duration(days: 1)),
        priority: Priority.high,
      ),
      TaskModel(
        id: 'task2',
        title: 'Task 2',
        description: 'This is task 2',
        dueDate: DateTime.now().add(Duration(days: 2)),
        priority: Priority.medium,
      ),
    ];

    test('should call getAllTasks method on repository with correct parameters', () async {
      // Arrange
      when(() => mockTaskRepository.getAllTasks(userId)).thenAnswer((_) async => Right(tasks));

      // Act
      await getAllTaskUsecase(userId);

      // Assert
      verify(() => mockTaskRepository.getAllTasks(userId)).called(1);
    });

    test('should return a Failure when the repository fails to fetch tasks', () async {
      // Arrange
      final failure = Failure('Error fetching tasks');
      when(() => mockTaskRepository.getAllTasks(userId)).thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllTaskUsecase(userId);

      // Assert
      expect(result, Left(failure));
    });

    test('should return a list of tasks when the repository succeeds', () async {
      // Arrange
      when(() => mockTaskRepository.getAllTasks(userId)).thenAnswer((_) async => Right(tasks));

      // Act
      final result = await getAllTaskUsecase(userId);

      // Assert
      expect(result, Right(tasks));
    });

    // test('should return an empty list if no tasks are found', () async {
    //   // Arrange
    //   when(() => mockTaskRepository.getAllTasks(userId)).thenAnswer((_) async => Right( []  ));

    //   // Act
    //   final result = await getAllTaskUsecase(userId);

    //   // Assert
    //   expect(result, Right([]));  // Expecting an empty list of tasks
    // });
  });
}
