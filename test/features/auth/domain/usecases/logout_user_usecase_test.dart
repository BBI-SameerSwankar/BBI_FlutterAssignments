import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/logout_user_usecase.dart';

// Create a Mock class for AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUserUsecase logoutUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    // Initialize the mock repository and the use case
    mockAuthRepository = MockAuthRepository();
    logoutUserUsecase = LogoutUserUsecase(mockAuthRepository);
  });

  group('LogoutUserUsecase', () {
    test('should return a failure when logout fails', () async {
      // Arrange: Mock the repository's logout method to return a failure
      when(() => mockAuthRepository.logoutUser()).thenAnswer(
        (_) async => Left(Failure('Logout failed')),
      );

      // Act: Call the use case
      final result = await logoutUserUsecase.call();

      // Assert: Check that the result is a Left (failure)
      expect(result.isLeft(), true);
      // expect(result.fold((l) => l, (r) => r), isA<Failure>());
      expect(result.fold((l) => l.message, (r) => ''), 'Logout failed');
    });

    test('should return a void when logout succeeds', () async {
      // Arrange: Mock the repository's logout method to return a successful result
      when(() => mockAuthRepository.logoutUser()).thenAnswer(
        (_) async => Right(null),
      );

      // Act: Call the use case
      final result = await logoutUserUsecase.call();

      // Assert: Check that the result is a Right (success)
      expect(result.isRight(), true);
      // expect(result.fold((l) => null, (r) => r), null);
    });
  });
}
