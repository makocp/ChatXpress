import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final authService = serviceContainer<AuthService>();
  currentUserID() =>
      authService.firebaseAuthInstance.currentUser?.uid.toString();

  // Creates a new user, if it does not exist.
  // If it DOES exist it updates the sent fields, without deleting the others (merge true).
  // This merge option is only, if something failed during account creation -> user gets created after new sign in, just in case.
  Future<void> setUser(String email) async {
    return await db
        .collection('users')
        .doc(currentUserID())
        .set({"email": email}, SetOptions(merge: true));
  }

  Future<void> deleteUser() async {}

  Future<void> getUser() async {}

  // to add a message to the db with chatId as mapping to a chat.
  addMessage(MessageModel message) async {
    await db.collection('messages').add(message.mapToDB());
  }

  // to set a chat to the db.
  // gets updated, if document exists, but field changes (e.g. title) -> Setoptions merge: true (same as update, but creates document, if does not exist -> update would throw error).
  setChat(String chatId, String title) async {
    await db.collection('chats').doc(chatId).set(
        {'title': title, 'userId': currentUserID()}, SetOptions(merge: true));
  }

  // getChats() async {
  //   return await db
  //       .collection('users')
  //       .doc(currentUserID())
  //       .collection('chats')
  //       .get()
  //       .then((querySnapshot) {
  //     for (var docSnapchat in querySnapshot.docs) {
  //       log('${docSnapchat.id} => ${docSnapchat.data()}');
  //     }
  //   });
  // }
}
