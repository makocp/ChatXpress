import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final authService = serviceContainer<AuthService>();

  Future<void> saveUserToDb(String email) async {
    return await db
        .collection('users')
        .doc(authService.firebaseAuthInstance.currentUser?.uid.toString())
        .set({"email": email});
  }
}
