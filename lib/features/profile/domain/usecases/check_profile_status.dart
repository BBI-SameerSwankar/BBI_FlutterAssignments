import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';

class CheckProfileStatusUseCase {
  final ProfileRepository repository;

  CheckProfileStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call(String userId) {
    return repository.checkProfileStatus(userId);
  }
}
