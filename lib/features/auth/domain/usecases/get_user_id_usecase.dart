

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';

import 'package:task_app/features/auth/domain/repository/auth_repository.dart';





class GetUserIdUsecase {
  final AuthRepository authRepository;
  GetUserIdUsecase(this.authRepository);

  Future<Either<Failure ,UserModel >> call() async
  {
    return await authRepository.getUserIdFromLocal();
  }


}