import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/chat/chat_view.dart';
import 'package:chatXpress/views/sign_in/sign_in_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {

    // Gets called on first start on App -> start SignIn.
    // Listen on SignIn/SignOut event from Authentication and recalls builder
    // -> If user signs in/out it reloads the corresponding View (directly Chat or SignIn).
    // Registers needed services after each session change.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          unregisterAuthServices();
          return ChatView();
        } else {
          registerAuthServices();
          return SignInView();
        }
      },
    );
  }
}
