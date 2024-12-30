import 'package:flutter_test/flutter_test.dart';

import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/create_user_usecase.dart';

// Create a Mock class for AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CreateUserUsecase createUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    createUserUsecase = CreateUserUsecase(mockAuthRepository);
  });

  group('CreateUserUsecase', () {
    final tUser = UserModel("user_1"); // Example UserModel
    final tFailure = Failure(); // Example Failure class

    test('should return a UserModel when the repository call is successful', () async {
      // Arrange
      when(()=>mockAuthRepository.createUser()).thenAnswer(
        (_) async => Right( tUser ), // mock the return value correctly
      );

      // Act
      final result = await createUserUsecase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right, got Left'), // Expecting a Right
        (r) => expect(r, tUser), // Expect the result to be the tUser object
      );

      verify(()=> mockAuthRepository.createUser()).called(1); // Ensure that the method was called once
    });

    test('should return a Failure when the repository call fails', () async {
      // Arrange
      when(()=> mockAuthRepository.createUser()).thenAnswer(
        (_) async => Left(tFailure), // mock the return value as Left (Failure)
      );

      // Act
      final result = await createUserUsecase();

      // Assert
      expect(result.isLeft(), true); // Expecting a Left (Failure)
      result.fold(
        (l) => expect(l, tFailure), // Expect the failure to be tFailure
        (r) => fail('Expected Left, got Right'), // We should not get a Right here
      );

      verify(()=>mockAuthRepository.createUser()).called(1); // Ensure that the method was called once
    });
  });
}
