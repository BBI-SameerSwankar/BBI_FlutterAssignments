




import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';


abstract class AuthRepository {

  Future<Either<Failure,UserModel >> createUser();
  Future<Either<Failure,UserModel >> loginUser(UserModel user);
  Future<Either<Failure,void >> logoutUser();
  Future<Either<Failure,UserModel >> getUserIdFromLocal();


} 

