import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/error/failure.dart';
import 'package:task_app/core/utils/shared_preference_helper.dart';
import 'package:task_app/features/auth/domain/entity/user_model.dart';
import 'package:task_app/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/get_user_id_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUsecase createUserUsecase;
  final LoginUserUsecase loginUserUsecase;
  final LogoutUserUsecase logoutUserUsecase;
  final GetUserIdUsecase getUserIdUsecase;

  AuthBloc({
    required this.createUserUsecase,
    required this.loginUserUsecase,
    required this.logoutUserUsecase,
    required this.getUserIdUsecase,
  }) : super(AuthInitial()) {
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutUserEvent>(_onLogoutUser);
    on<CreateUserEvent>(_onCreateUser);
    on<GetUserIdFromLocal>(_onGetUserIdFromLocal);
  }

  // Function to handle login event
  Future<void> _onLoginUser(LoginUserEvent event, Emitter<AuthState> emit) async {
    
    emit(AuthLoading());
    UserModel user =  UserModel(event.userId); 
    final result = await loginUserUsecase.call( user  );

    result.fold(
      (failure) => emit(AuthError(message: failure.message.toString())),
      (result) => emit(UserLoggedIn( userId:  result.userId)),
    );
  }

 Future<void> _onGetUserIdFromLocal(GetUserIdFromLocal event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await getUserIdUsecase.call();
    print("hadsfdf");
  
    result.fold(
      (failure) 
      {
              print(failure.message);
              emit(AuthInitial());
            // emit(AuthError(message: failure.toString()));
      },
      (userModel) {
        if (userModel.userId.isNotEmpty) {
          emit(UserLoggedIn(userId: userModel.userId));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }


  


  Future<void> _onLogoutUser(LogoutUserEvent event, Emitter<AuthState> emit) async {

    print("logout");
    emit(AuthLoading());
 

    final result = await logoutUserUsecase.call();
    print(result);

    result.fold(
      (failure) { 
        print(failure.message);
        emit(AuthError(message: failure.toString())); 
        },
      (_) => emit(AuthInitial()),
    );
  }

 
  Future<void> _onCreateUser(CreateUserEvent event, Emitter<AuthState> emit) async {
    
    emit(AuthLoading());

    final result = await createUserUsecase.call();

    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (result) => emit(UserLoggedIn( userId:  result.userId)),
    );
  }
 
  // Future<void> _onCreateUser(CreateUserEvent event, Emitter<AuthState> emit) async {
    
  //   emit(AuthLoading());

  //   final result = await createUserUsecase.call();

  //   result.fold(
  //     (failure) => emit(AuthError(message: failure.toString())),
  //     (result) => emit(UserLoggedIn( userId:  result.userId)),
  //   );
  // }
}
