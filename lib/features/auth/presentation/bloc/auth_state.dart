import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {
  final User user;

  AuthSignedIn({required this.user});
}



class AuthSignedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError( this.message);
}
