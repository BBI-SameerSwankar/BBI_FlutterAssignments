

import 'package:fpdart/fpdart.dart';
import 'package:sellphy/core/error/failures.dart';
import 'package:sellphy/features/auth/domain/entities/auth_entity.dart';
import 'package:sellphy/features/auth/domain/repositories/auth_repository.dart';






class GetUserIdUsecase {
  final AuthRepository authRepository;
  GetUserIdUsecase(this.authRepository);

  Future<Either<Failure , String >> call() async
  {
    return await authRepository.getUserIdFromLocal();
  }


}