import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';

class SignInViewmodel {
  final authService = serviceContainer<AuthService>();
  final db = serviceContainer<FirestoreService>();

  signInAndSetToDb(String email, String password) {
    signInWithEmailAndPassword(email, password).then((value) {
      // To create the user, if it does not exist, but a Auth Acc exists.
      // Just in case, if there was an error in SignUp with account creation in Db.
      // Does NOT overwrite current user -> see origin db method (merge true).
      setUserToDB(email);
    });
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithGoogle() async {
    return await authService.signInWithGoogle();
  }

  Future<UserCredential> signInWithApple() async {
    return await authService.signInWithApple();
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }
}
