

abstract class AuthState {}

// select
class AuthInitial extends AuthState{}


class AuthLoading extends AuthState{}

// incorrect form
class AuthError extends AuthState{
  final String message;
  AuthError({required this.message});
}

// create, login
class UserLoggedIn extends AuthState{
  final String userId;
  UserLoggedIn({required this.userId});
}

// form
class UserRegister extends AuthState{
  
}