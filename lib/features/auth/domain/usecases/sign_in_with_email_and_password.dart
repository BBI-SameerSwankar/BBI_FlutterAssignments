
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_entity.dart';

class SignInWithEmailAndPassword {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);


  Future<Either<Failure, User>> call(String email,String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}

