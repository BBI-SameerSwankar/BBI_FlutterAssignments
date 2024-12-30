import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';


abstract class UserRemoteDataSource {
  Future<Either<Failure, UserModel>> createUser();
  Future<Either<Failure, UserModel>> loginUser(UserModel user);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final AuthLocalDataSource _authLocalDataSource; // Inject AuthLocalDataSource

  UserRemoteDataSourceImpl(this._firebaseDatabase, this._authLocalDataSource);

  DatabaseReference get usersRef => _firebaseDatabase.ref('Users');
  DatabaseReference get userCountRef => _firebaseDatabase.ref('Usercount');

  Future<Either<Failure, UserModel>> createUser() async {
    try {
      final snapshot = await userCountRef.get();
      final currentUserId = snapshot.exists && snapshot.value != null
          ? (snapshot.value as int)
          : 0;
 
      final newUserId = 'user_${currentUserId + 1}';
      await userCountRef.set(currentUserId + 1);
      // Create a new user in the database
    print(newUserId);
      await usersRef.child(newUserId).set({
        'userId': newUserId,
      });
   print("here");

      // Save user ID locally after successful creation
      await _authLocalDataSource.saveUserId(newUserId);

      return Right(UserModel(newUserId));
    } catch (error) {
      return Left(Failure('Failed to create user: $error'));
    }
  }

  Future<Either<Failure, UserModel>> loginUser(UserModel user) async {
    try {
      final snapshot = await usersRef.child(user.userId).get();

      if (snapshot.exists) {
        // Save user ID locally after successful login
        await _authLocalDataSource.saveUserId(user.userId);
        return Right(user); 
      } else {
        return Left(Failure('User not registered'));
      }
    } catch (error) {
      return Left(Failure('Failed to login: $error'));
    }
  }
}
