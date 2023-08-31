import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firebaseAuthInstance = FirebaseAuth.instance;

  Future<GoogleSignInAccount> signInWithGoogle() async {
    // Starts the interactive sign-in process.
    // null if sign in failed.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // get auth details for request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in
    await firebaseAuthInstance.signInWithCredential(credential);
    return gUser;
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await firebaseAuthInstance.signInWithProvider(appleProvider);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await firebaseAuthInstance.sendPasswordResetEmail(email: email);
  }

  Future<void> sendPasswordReset() async {
    var email = firebaseAuthInstance.currentUser!.email;
    if (email != null) {
      return await firebaseAuthInstance.sendPasswordResetEmail(email: email);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await firebaseAuthInstance.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> updatePassword(String newPassword) async {
    return await firebaseAuthInstance.currentUser?.updatePassword(newPassword);
  }

  Future<void> logOut() async {
    await firebaseAuthInstance.signOut();
  }
}
