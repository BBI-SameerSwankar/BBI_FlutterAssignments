

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';





class LoginUserUsecase {
  final AuthRepository authRepository;
  LoginUserUsecase(this.authRepository);

  Future<Either<Failure ,UserModel >> call(UserModel user)
  {

    return authRepository.loginUser(user);
  }


}