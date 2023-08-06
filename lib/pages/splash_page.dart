import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/pages/start_page.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          color: MyColors.greenDefaultColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/chatXpress.png'),
              const SizedBox(height: 20),
              const DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  child: Text("ChatXpress"))
            ],
          )),
    );
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const StartPage()));
  }
}
