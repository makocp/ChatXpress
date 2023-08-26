import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final authService = serviceContainer<AuthService>();

  // Creates a new user, if it does not exist.
  // If it DOES exist it updates the sent fields, without deleting the others (merge true).
  // This merge option is only, if something failed during account creation -> user gets created after new sign in, just in case.
  Future<void> setUser(String email, String username) async {
    // Check if the user with the given email already exists
    QuerySnapshot userSnapshot = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // If a user with the given email exists, update their information
    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs[0].id;
      await db.collection('users').doc(userId).set(
        {"username": username},
        SetOptions(merge: true),
      );
    } else {
      // If no user with the given email exists, create a new user document
      await db.collection('users').add({
        "email": email,
        "username": username.split(" ")[0],
      });
    }
  }


  Future<void> deleteUser() async {}

  Future<void> getUser() async {}
}
