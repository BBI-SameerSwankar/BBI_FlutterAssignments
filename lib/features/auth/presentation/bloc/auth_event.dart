abstract class AuthEvent {}

class SignInWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailAndPasswordEvent({required this.email, required this.password});
}


class SignInWithGoogleEvent extends AuthEvent {}

class SignUpWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailAndPasswordEvent({required this.email, required this.password});
}

class SignOutEvent extends AuthEvent {}
