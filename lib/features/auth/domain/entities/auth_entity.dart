class AuthEntity {
  final String idToken;
  final String email;
  final String? password;

  AuthEntity({required this.idToken, required this.email, this.password});

  
  factory AuthEntity.fromFirebaseUser({required String idToken, required String email, String? password}) {
    return AuthEntity(idToken: idToken, email: email, password: password);
  }
}
