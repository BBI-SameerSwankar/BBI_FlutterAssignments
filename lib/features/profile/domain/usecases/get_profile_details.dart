import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, ProfileModel>> call(String userId) {
    return repository.getProfile(userId);
  }
}
