import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/colors/my_image_paths.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/views/start/start_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: MyColors.greenDefaultColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(MyImagePaths.iconPath),
          const SizedBox(height: 20),
          const DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
              child: Text(MyStrings.appName))
        ],
      ),
    );
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const StartView()));
  }
}
