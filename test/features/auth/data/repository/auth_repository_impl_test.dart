import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:task_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

// Mocks
class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}
class MockLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    authRepository = AuthRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('AuthRepositoryImpl', () {
    final userModel = UserModel('user123'); // Mock user ID

    test('should successfully create a user', () async {
      // Arrange
      when(() => mockRemoteDataSource.createUser()).thenAnswer(
        (_) async => Right(userModel),
      );

      // Act
      final result = await authRepository.createUser();

      // Assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(() => null), equals(userModel));
    });

    test('should return Failure when creating a user fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.createUser()).thenThrow(Exception('Error'));

      // Act
      final result = await authRepository.createUser();

      // Assert
      expect(result.isLeft(), true);
      // expect(result.swap().getOrElse(() => Failure('')).message, contains('Error creating user'));
    });

    test('should successfully log in a user', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userModel)).thenAnswer(
        (_) async => Right(userModel),
      );

      // Act
      final result = await authRepository.loginUser(userModel);

      // Assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(() => null), equals(userModel));
    });

    test('should return Failure when logging in a user fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userModel)).thenThrow(Exception('Error'));

      // Act
      final result = await authRepository.loginUser(userModel);

      // Assert
      expect(result.isLeft(), true);
      // expect(result.swap().getOrElse(() => Failure('')).message, contains('Error logging in user'));
    });

    test('should successfully get user ID from local storage', () async {
      // Arrange
      when(() => mockLocalDataSource.getUserId()).thenAnswer(
        (_) async => 'user123',
      );

      // Act
      final result = await authRepository.getUserIdFromLocal();

      // Assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(() => null)?.id, equals('user123'));
    });

    test('should return Failure if no user ID found in local storage', () async {
      // Arrange
      when(() => mockLocalDataSource.getUserId()).thenAnswer(
        (_) async => null,
      );

      // Act
      final result = await authRepository.getUserIdFromLocal();

      // Assert
      expect(result.isLeft(), true);
      // expect(result.swap().getOrElse(() => Failure('')).message, contains('No user ID found in local storage'));
    });

    test('should successfully log out a user', () async {
      // Arrange
      when(() => mockLocalDataSource.clearUserId()).thenAnswer(
        (_) async => null,
      );

      // Act
      final result = await authRepository.logoutUser();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return Failure when logging out fails', () async {
      // Arrange
      when(() => mockLocalDataSource.clearUserId()).thenThrow(Exception('Error'));

      // Act
      final result = await authRepository.logoutUser();

      // Assert
      expect(result.isLeft(), true);
      // expect(result.swap().getOrElse(() => Failure('')).message, contains('Error logging out user'));
    });
  });
}
