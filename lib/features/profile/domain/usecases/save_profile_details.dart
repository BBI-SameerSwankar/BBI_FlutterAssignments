import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(ProfileModel profileModel, String userId) {
    return repository.saveProfile(profileModel, userId);
  }
}
