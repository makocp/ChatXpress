import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final authService = serviceContainer<AuthService>();
  currentUserID() =>
      authService.firebaseAuthInstance.currentUser?.uid.toString();

  
  // CREATE
  // Creates a new user, if it does not exist.
  // If it DOES exist it updates the sent fields, without deleting the others (merge true).
  // This merge option is only, if something failed during account creation -> user gets created after new sign in, just in case.
  Future<void> setUser(String email) async {
    return await db
        .collection('users')
        .doc(authService.firebaseAuthInstance.currentUser?.uid.toString())
        .set({"email": email}, SetOptions(merge: true));
  }

  // CREATE
  // to add a message to the db with chatId as mapping to a chat.
  addMessage(MessageModel message) async {
    await db.collection('messages').add(message.mapToDB());
  }

  // CREATE / UPDATE
  // to set a chat to the db.
  // gets updated, if document exists, but field changes (e.g. title) -> Setoptions merge: true (same as update, but creates document, if does not exist -> update would throw error).
  setChat(String chatId, String title) async {
    await db.collection('chats').doc(chatId).set(
        {'title': title, 'userId': currentUserID(), 'date': DateTime.now()}, SetOptions(merge: true));
  }

  // READ
  Future<QuerySnapshot<Map<String, dynamic>>> getCurrentUserchats() async {
    return await db
        .collection('chats')
        .orderBy('date', descending: true)
        .where('userId', isEqualTo: currentUserID())
        // GetOptions -> by default ServerAndCache (Loads from Server, but from Cache, if Server not available).
        .get();
  }

  // READ
  Future<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatId) async {
    return await db
        .collection('messages')
        .orderBy('date', descending: false)
        .where('chatId', isEqualTo: chatId)
        .get();
  }

  // DELETE
  Future deleteChats() async {
    await db
        .collection('chats')
        .where('userId', isEqualTo: currentUserID())
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> updateChatTitle(String chatId,String title) async{
    await db.collection('chats').doc(chatId).set(
        {'title': title}, SetOptions(merge: true));
  }
}