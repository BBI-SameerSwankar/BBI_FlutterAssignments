import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sellphy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sellphy/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sellphy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sellphy/features/auth/domain/repositories/auth_repository.dart';
import 'package:sellphy/features/auth/domain/usecases/forget_password.dart';
import 'package:sellphy/features/auth/domain/usecases/get_user_id_for_local.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_out.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sellphy/features/product/data/data_sources/remote_data_source.dart';
import 'package:sellphy/features/product/data/repositories/respository_impl.dart';
import 'package:sellphy/features/product/domain/repositories/repository.dart';
import 'package:sellphy/features/product/domain/usecases/add_item_to_cart.dart';
import 'package:sellphy/features/product/domain/usecases/get_cart_items.dart';
import 'package:sellphy/features/product/domain/usecases/get_favourite_products_id_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/get_products_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/remove_item_from_cart.dart';
import 'package:sellphy/features/product/domain/usecases/toggle_favourite_usecase.dart';
import 'package:sellphy/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:sellphy/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sellphy/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sellphy/features/profile/domain/repositories/profile_repository.dart';
import 'package:sellphy/features/profile/domain/usecases/check_profile_status.dart';
import 'package:sellphy/features/profile/domain/usecases/get_profile_details.dart';
import 'package:sellphy/features/profile/domain/usecases/save_profile_details.dart';
import 'package:sellphy/features/profile/domain/usecases/update_profile_details.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  locator.registerLazySingleton<GetUserIdUsecase>(() => GetUserIdUsecase(locator<AuthRepository>( )));
  locator.registerLazySingleton<ForgotPasswordUsecase>(() => ForgotPasswordUsecase(locator<AuthRepository>( )));

  // locator.registerLazySingleton<GetUserIdUsecase>(() => GetUserIdUsecase(locator<AuthRepository>()));


  
  // Register AuthBloc
  locator.registerFactory<AuthBloc>(() => AuthBloc(
      signInWithEmailAndPasswordUseCase: locator(),
      signOutUseCase: locator(),
      signInWithGoogleUseCase: locator(),
      signUpWithEmailAndPasswordUseCase: locator(),
      getUserIdUsecase: locator(),
      forgotPasswordUsecase: locator()
     
  ));


  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);  

  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      locator(),
    ),
  );

  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      locator(),
    ),
  );

  locator.registerLazySingleton<CheckProfileStatusUseCase>(
    () => CheckProfileStatusUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(
      locator(),
    ),
  );



  locator.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      saveProfileUseCase: locator(),
      updateprofileUsecase: locator(),
      getProfileUsecase: locator(),
     
    ),
  );



  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(locator(),locator()));

  locator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(locator()));
  // UseCases
  locator.registerLazySingleton<GetProductsUsecase>(() => GetProductsUsecase( locator() ));

  locator.registerLazySingleton<AddItemToCart>(() => AddItemToCart( locator() ));
  locator.registerLazySingleton<GetCartItems>(() => GetCartItems( locator() ));
  locator.registerLazySingleton<RemoveItemFromCart>(() => RemoveItemFromCart( locator() ));

  locator.registerLazySingleton<GetFavouriteProductsIdUsercase>(() => GetFavouriteProductsIdUsercase( locator() ));
  locator.registerLazySingleton<ToggleFavouriteUsecase>(() => ToggleFavouriteUsecase( locator() ));



  locator.registerFactory<ProductBloc>(() => ProductBloc(
    getProductsUsecase:  locator(),
    getFavouriteProductsIdUsercase: locator(),
    toggleFavouriteUsecase: locator()
 
    ));


  locator.registerFactory<CartBloc>(() => CartBloc(
    getProductsUsecase:  locator(),
    addItemToCart: locator(),
    getCartItems: locator(),
    removeItemFromCart: locator()
    ));



}