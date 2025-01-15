
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';


class SignUpWithEmailAndPassword {
  final AuthRepository repository;

  SignUpWithEmailAndPassword(this.repository);


  Future<Either<Failure, User>> call(String email,String password) async {
    return await repository.signUpWithEmailAndPassword(email, password);
  }
}


