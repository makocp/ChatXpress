import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpViewmodel {
  final authService = serviceContainer<AuthService>();
  final db = serviceContainer<FirestoreService>();

  // Creates an account in FirebaseAuth, if successful -> signIn and save user to database.
  createAccountAndSignIn(String email, String password, Function popView) {
    createUserWithEmailAndPassword(email, password).then((value) {
      signInWithEmailAndPassword(email, password);
      setUserToDB(email);
      // This pop method is necessary to pop the SignUpView and get to the ChatView.
      // -> Previous SignInView changed to ChatView, because of authStateChange in StartView.
      // Otherwise the SignUpView would "overwrite" the ChatView.
      // -> See Widget Tree in Widget inspector for details and better understanding.
      popView();
    });
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await authService.createUserWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }
}
