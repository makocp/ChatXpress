import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final authService = serviceContainer<AuthService>();

  // Creates a new user, if it does not exist.
  // If it DOES exist it updates the sent fields, without deleting the others (merge true).
  // This merge option is only, if something failed during account creation -> user gets created after new sign in, just in case.
  Future<void> setUser(String email,String username) async {
    return await db
        .collection('users')
        .doc(authService.firebaseAuthInstance.currentUser?.uid.toString())
        .set({"email": email, "username": username}, SetOptions(merge: true));
  }

  Future<void> deleteUser() async {}

  Future<void> getUser() async {}
}
