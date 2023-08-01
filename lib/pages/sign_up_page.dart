import 'dart:developer';

import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  SignUpPage({super.key});

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

        const SizedBox(height: 50),
        MyTextfield(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            icon: Icons.email_outlined),

        const SizedBox(height: 25),
        MyTextfield(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
            icon: Icons.lock_outline),

        const SizedBox(height: 25),
        MyTextfield(
            controller: passwordConfirmationController,
            hintText: 'Confirm Password',
            obscureText: true,
            icon: Icons.lock_outline),

        const SizedBox(height: 50),
        MyButton(
          onTap: () => {
            // Input Checks add, format UI, message Errors (usablity).
            if (passwordController.text == passwordConfirmationController.text)
              {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }).onError((error, stackTrace) {
                  log('Error ${error.toString()}');
                })
              },
          },
          buttonText: 'Create Account',
        ),

        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already a member? ',
              style: TextStyle(color: MyColors.greenDefaultColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Sign In.',
                style: TextStyle(
                    color: MyColors.greenDefaultColorDark,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ]),
    );
  }
}
