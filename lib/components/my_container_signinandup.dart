import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

// The purpose of this class is to use it as framework in a SCAFFOLD for background, padding, etc. for the SignIn and SignUp Page to avoid redundancy.
class MyContainerSignInAndUp extends StatelessWidget {
  final List<Widget> columnPageContent;

  const MyContainerSignInAndUp({
    super.key,
    required this.columnPageContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [MyColors.greenDefaultColor, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      // child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
            child: ListView(
              // To hide the keyboard, when swipe -> better usability.
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: columnPageContent,
            ),
          ),
        ),
      // ),
    );
  }
}
