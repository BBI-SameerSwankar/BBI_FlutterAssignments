import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';


abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> signUpWithEmailAndPassword(String email, String password);
  Future<Either<Failure, String>> getUserIdFromLocal();
  Future<Either<Failure, void>> forgotPassword(String email);
}
