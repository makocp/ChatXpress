import 'package:chatXpress/views/chat/chat_view.dart';
import 'package:chatXpress/views/sign_in/sign_in_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ChatView();
        } else {
          return SignInView();
        }
      },
    );
  }
}