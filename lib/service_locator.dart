import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:task_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/get_user_id_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() async{
 
    final sharedPreferences = await SharedPreferences.getInstance();

  // Register FirebaseRemoteDataSource and AuthLocalDataSource
  locator.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);
  locator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences) );  // Assume AuthLocalDataSourceImpl is implemented
  
  // Register your RemoteDataSource and Repository
  locator.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
      locator(), 
      locator()
  ));

  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      locator(), 
      locator()
  ));

  // Register use cases
  locator.registerLazySingleton<CreateUserUsecase>(() => CreateUserUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton<LoginUserUsecase>(() => LoginUserUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton<LogoutUserUsecase>(() => LogoutUserUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton<GetUserIdUsecase>(() => GetUserIdUsecase(locator<AuthRepository>()));
  
  // Register AuthBloc
  locator.registerFactory<AuthBloc>(() => AuthBloc(
      createUserUsecase: locator<CreateUserUsecase>(),
      loginUserUsecase: locator<LoginUserUsecase>(),
      logoutUserUsecase: locator<LogoutUserUsecase>(),
      getUserIdUsecase: locator<GetUserIdUsecase>(),
  ));
}
