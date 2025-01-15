
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';


class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);


  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
