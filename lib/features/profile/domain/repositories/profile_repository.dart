

import 'package:fpdart/fpdart.dart';

import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId);
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId);

  Future<Either<Failure,bool>> checkProfileStatus(String userId);
}