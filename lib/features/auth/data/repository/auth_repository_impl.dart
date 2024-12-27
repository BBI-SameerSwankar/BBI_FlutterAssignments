import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:task_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';


class AuthRepositoryImpl extends AuthRepository {

  final UserRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;


  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, UserModel>> createUser() async {
    try {   
      return await remoteDataSource.createUser();
    } catch (e) {
      return Left(Failure('Error creating user: ${e.toString()}'));
    }
  }



  @override
  Future<Either<Failure, UserModel>> loginUser(UserModel user) async {
    try {

      return await remoteDataSource.loginUser(user);
    } catch (e) {
      
      return Left(Failure('Error logging in user: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> getUserIdFromLocal() async {
    try {
      final userId = await localDataSource.getUserId();
      if (userId != null) {
        return Right(UserModel( userId));  // Assuming UserModel can be created with just an ID.
      } else {
        return Left(Failure('No user ID found in local storage.'));
      }
    } catch (e) {
      return Left(Failure('Error getting user ID from local storage: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await localDataSource.clearUserId();
      return const Right(null);
    } catch (e) {
      return Left(Failure('Error logging out user: ${e.toString()}'));
    }
  }


  

  
}
