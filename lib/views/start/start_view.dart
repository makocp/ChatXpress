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
          // Gets called, after ChatView is rendered.
          // !! otherwise it would pop and unregister, but the ChatView is not loaded yet -> error.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // to pop SignUpView, if user creates account successfully
            // otherwise it would "overwrite" the ChatView
            Navigator.popUntil(context, (route) => route.isFirst);
            // to unregister all AuthServices, because no longer needed after SignIn.
            unregisterAuthServices();
          });
          return ChatView();
        } else {
          registerAuthServices();
          return SignInView();
        }
      },
    );
  }
}
