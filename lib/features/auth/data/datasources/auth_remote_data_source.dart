import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellphy/features/auth/data/datasources/auth_local_data_source.dart';


abstract class AuthRemoteDataSource {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<void> forgotPassword(String email);

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final AuthLocalDataSource authLocalDataSource;

  AuthRemoteDataSourceImpl({                                                                                               
    required this.firebaseAuth,
    required this.authLocalDataSource,
  });

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {

      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    
    
      if (userCredential.user != null) {
        await authLocalDataSource.saveUserId(userCredential.user!.uid);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      throw Exception("Failed to sign in with email and password");
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
 
      print("google sign in goin on");
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final userCredential = await firebaseAuth.signInWithProvider(googleProvider);

      
      if (userCredential.user != null) {
        await authLocalDataSource.saveUserId(userCredential.user!.uid);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw Exception("Google sign-in failed");
    }
  }

  @override
  Future<void> signOut() async {
    try {

      await firebaseAuth.signOut();

      await authLocalDataSource.clearUserId();
    } catch (e) {
      throw Exception("Failed to sign out");
    }
  }


  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
    
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

     
      if (userCredential.user != null) {
        await authLocalDataSource.saveUserId(userCredential.user!.uid);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      throw Exception("Failed to sign up with email and password: $e");
    }
  }


  @override
  Future<void> forgotPassword(String email) async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
 
    }
    catch(e){

      print("error in reseting password ${e}");

      throw Exception("Error while reseting password");
    }
  }

}
