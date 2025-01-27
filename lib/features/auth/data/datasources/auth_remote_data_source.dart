import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellphy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';


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
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await authLocalDataSource.saveUserId(userCredential.user!.uid);
        return userCredential.user;
      }
    }
    return null;
  } catch (e) {
    print("Error in Google sign-in: $e");
    throw Exception("Google sign-in failed");
  }
}


@override
Future<void> signOut() async {
  try {
  
    await firebaseAuth.signOut();

 
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

 
    await authLocalDataSource.clearUserId();
  } catch (e) {
    throw Exception("Failed to sign out: $e");
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
