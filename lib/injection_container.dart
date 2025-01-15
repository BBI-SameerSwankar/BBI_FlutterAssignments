import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sellphy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sellphy/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sellphy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sellphy/features/auth/domain/repositories/auth_repository.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_out.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

void setupLocator() async{
 
    final sharedPreferences = await SharedPreferences.getInstance();

  // Register FirebaseRemoteDataSource and AuthLocalDataSource
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences) );  // Assume AuthLocalDataSourceImpl is implemented
  
  // Register your RemoteDataSource and Repository
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
    firebaseAuth:  locator(), 
    authLocalDataSource:   locator()
  ));




  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
     remoteDataSource:  locator(), 
     localDataSource: locator()
  
  ));

  // Register use cases
  locator.registerLazySingleton<SignInWithEmailAndPassword>(() => SignInWithEmailAndPassword(locator<AuthRepository>()));
  locator.registerLazySingleton<SignInWithGoogle>(() => SignInWithGoogle(locator<AuthRepository>()));
  locator.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(locator<AuthRepository>()));                  
  locator.registerLazySingleton<SignUpWithEmailAndPassword>(() => SignUpWithEmailAndPassword(locator<AuthRepository>()));

  // locator.registerLazySingleton<GetUserIdUsecase>(() => GetUserIdUsecase(locator<AuthRepository>()));


  
  // Register AuthBloc
  locator.registerFactory<AuthBloc>(() => AuthBloc(
      signInWithEmailAndPasswordUseCase: locator(),
      signOutUseCase: locator(),
      signInWithGoogleUseCase: locator(),
      signUpWithEmailAndPasswordUseCase: locator()
     
  ));

}