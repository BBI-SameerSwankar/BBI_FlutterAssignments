import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/login_user_usecase.dart';

// Create a Mock class for AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUserUsecase loginUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    // Initialize the mock repository and the use case
    mockAuthRepository = MockAuthRepository();
    loginUserUsecase = LoginUserUsecase(mockAuthRepository);
  });

  group('LoginUserUsecase', () {
    const tUser = UserModel('12345');  // Sample user model for testing

    test('should return a failure when login fails', () async {
      // Arrange: Mock the repository's loginUser method to return a failure
      when(() => mockAuthRepository.loginUser(tUser)).thenAnswer(
        (_) async => Left(Failure('Login failed')),
      );

      // Act: Call the use case
      final result = await loginUserUsecase.call(tUser);

      // Assert: Check that the result is a Left (failure)
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<Failure>());
      expect(result.fold((l) => l.message, (r) => ''), 'Login failed');
    });

    test('should return a UserModel when login succeeds', () async {
      // Arrange: Mock the repository's loginUser method to return a successful result
      when(() => mockAuthRepository.loginUser(tUser)).thenAnswer(
        (_) async => Right(tUser),
      );

      // Act: Call the use case
      final result = await loginUserUsecase.call(tUser);

      // Assert: Check that the result is a Right (success)
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), tUser);
    });
  });
}
