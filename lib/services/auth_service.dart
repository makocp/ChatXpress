import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future signInWithGoogle() async {
    // Starts the interactive sign-in process.
    // null if sign in failed.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // get auth details for request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create credidential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  resetPassword(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future singInWithCredentials(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future signUp(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      // If account creation was successfull, then the User gets Signed in.
      // -> This invokes the listener on the StartPage, which switches from LogInPage to HomePage.
      return FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }
}
