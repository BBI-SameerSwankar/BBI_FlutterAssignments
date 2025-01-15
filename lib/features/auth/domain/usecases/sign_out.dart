import 'package:fpdart/fpdart.dart';
import 'package:sellphy/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
