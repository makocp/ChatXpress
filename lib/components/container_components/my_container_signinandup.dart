import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/colors/my_image_paths.dart';
import 'package:flutter/material.dart';

// The purpose of this class is to use it as framework in a SCAFFOLD for background, padding, etc. for the SignIn and SignUp Page to avoid redundancy.
class MyContainerSignInAndUp extends StatelessWidget {
  final List<Widget> listViewContent;

  const MyContainerSignInAndUp({
    super.key,
    required this.listViewContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [MyColors.greenDefaultColor, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
          child: Column(
            children: [
              const Image(
                image: AssetImage(MyImagePaths.iconPath),
                height: 100,
              ),
              const SizedBox(height: 50),
              Expanded(
                child: ListView(
                  // To hide the keyboard, when swipe -> better usability.
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: listViewContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
