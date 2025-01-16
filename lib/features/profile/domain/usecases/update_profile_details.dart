import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(ProfileModel profileModel, String userId) {
    return repository.updateProfile(profileModel, userId);
  }
}
