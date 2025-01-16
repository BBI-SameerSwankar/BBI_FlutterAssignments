
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/auth/domain/usecases/get_user_id_for_local.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_out.dart';
import 'package:sellphy/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPassword signInWithEmailAndPasswordUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;
  final SignUpWithEmailAndPassword signUpWithEmailAndPasswordUseCase;
  final SignOutUseCase signOutUseCase;
  final GetUserIdUsecase getUserIdUsecase;

  AuthBloc({
    required this.signInWithEmailAndPasswordUseCase,
    required this.signInWithGoogleUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
    required this.signOutUseCase,
    required this.getUserIdUsecase,
  }) : super(AuthInitial()) {
    on<SignInWithEmailAndPasswordEvent>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPassword);
    on<SignOutEvent>(_onSignOut);
    on<GetUserIdFromLocal>(_onGetUserIdFromLocal);
   
  }

  Future<void> _onSignInWithEmailAndPassword( 
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print("login");
      emit(AuthLoading());
      final result = await signInWithEmailAndPasswordUseCase(
        event.email,
        event.password,
      );

      result.fold(
        (failure) { 
          print("failure ${failure.message}");
          emit(AuthError(failure.message ?? 'Login failed')); 
          },
        (user) {
          print("sucess");
          emit(AuthSignedIn(user: user));
          }
      );
    } catch (e) {
      emit(AuthError('An error occurred during login.'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
     
      final result = await signInWithGoogleUseCase();
      result.fold(
        (failure) =>
            emit(AuthError(failure.message ?? 'Google sign-in failed')),
        (user) => emit(AuthSignedIn(user: user)),
      );
    } catch (e) {
      emit(AuthError('An error occurred during Google sign-in.'));
    }
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
    print("create account");
      emit(AuthLoading());
      final result = await signUpWithEmailAndPasswordUseCase(
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message ?? 'Sign-up failed')),
        (user) => emit(AuthSignedIn(user: user)),
      );
    } catch (e) {
      emit(AuthError('An error occurred during sign-up.'));
    }
  }

  // Handle SignOut
  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result = await signOutUseCase();
      result.fold(
        (failure) => emit(    AuthError(failure.message ?? 'Sign-out failed')),
        (_) => emit(AuthSignedOut()), // Signed out state
      );
    } catch (e) {
      emit(AuthError('An error occurred during sign-out.'));
    }
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
      (userId) {
       
          final user = FirebaseAuth.instance.currentUser;
          print(user);
          emit(AuthSignedIn(user: user!));
       
      },
    );
  }

}
