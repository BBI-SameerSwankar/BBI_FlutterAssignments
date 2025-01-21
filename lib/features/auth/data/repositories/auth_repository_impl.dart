
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sellphy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sellphy/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final authModel = await remoteDataSource.signInWithEmailAndPassword(email, password);
      if (authModel != null) {
        return Right(authModel);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try{

      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    }
    catch(e)
    {
        return Left(Failure("Error while reseting password"));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final authModel = await remoteDataSource.signInWithGoogle();
      print(authModel);
      if (authModel != null) {
        return Right(authModel);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        return Right(user);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

    
  @override
  Future<Either<Failure, String>> getUserIdFromLocal() async {
    try {
      final userId = await localDataSource.getUserId();
      if (userId != null) {
        return Right(userId);  // Assuming UserModel can be created with just an ID.
      } else {
        return Left(Failure('No user ID found in local storage.'));
      }
    } catch (e) {
      return Left(Failure('Error getting user ID from local storage: ${e.toString()}'));
    }
  }
}
