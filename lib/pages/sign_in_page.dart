import 'dart:developer';

import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_squaretile.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/home_page.dart';
import 'package:chatXpress/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignInPage({super.key});

  // void signInUser() async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(columnPageContent: [
        // Icon
        const Image(
            image: AssetImage('lib/assets/images/chatXpress.png'), height: 100),

        // Email input
        const SizedBox(height: 50),
        MyTextfield(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            icon: Icons.email_outlined),

        // Password input
        const SizedBox(height: 25),
        MyTextfield(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
            icon: Icons.lock_outline),

        // Forgot password text
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot password?',
            style: TextStyle(
                color: MyColors.greenDefaultColorDark,
                fontWeight: FontWeight.w700),
          ),
        ),

        // SignIn button
        const SizedBox(height: 25),
        MyButton(
          onTap: () => {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text)
                .then((value) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }).onError((error, stackTrace) {
              log('Error ${error.toString()}');
            })
          },
          buttonText: 'Login',
        ),

        // Divider with text
        const SizedBox(height: 25),
        const Row(
          children: [
            Expanded(child: Divider(thickness: 1)),
            Text(
              'Or continue with',
              style: TextStyle(color: MyColors.greenDefaultColorDark),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),

        // Alternative Logins
        const SizedBox(height: 25),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MySquareTile(imagePath: 'lib/assets/images/google.png'),
            SizedBox(
              width: 20,
            ),
            MySquareTile(imagePath: 'lib/assets/images/apple.png'),
          ],
        ),

        // Register text
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Not a member? ',
              style: TextStyle(color: MyColors.greenDefaultColorDark),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: const Text(
                'Create account.',
                style: TextStyle(
                    color: MyColors.greenDefaultColorDark,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        )
      ]),
    );
  }
}