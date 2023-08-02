import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MyContainerSignInAndUp(columnPageContent: [
      const Expanded(child: SizedBox()),
      MyButton(
        buttonText: 'Logout',
        onTap: () {
          FirebaseAuth.instance.signOut()
          .then((value) {
            Navigator.popUntil(context, (route) => route.isFirst);
          })
          ;
        },
      ),
      const Expanded(child: SizedBox()),
    ]);
  }
}
