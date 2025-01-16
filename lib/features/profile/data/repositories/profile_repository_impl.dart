// data/repositories/profile_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';
import 'package:sellphy/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileModel>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfileFromRemote(userId);
      return Right(profile);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId) async {
    try {
      await remoteDataSource.updateProfileOnRemote(profileModel, userId);
      return Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId) async {
    try {
      await remoteDataSource.saveProfileOnRemote(profileModel, userId);
      return Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

 
  @override
  Future<Either<Failure, bool>> checkProfileStatus(String userId) async {
    try {
      final status = await remoteDataSource.checkProfileStatus(userId);
      return Right(status);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
