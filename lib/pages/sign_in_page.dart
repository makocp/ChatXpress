import 'dart:io';
import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_squaretile.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/forgot_password_page.dart';
import 'package:chatXpress/pages/sign_up_page.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(columnPageContent: [
        showIcon(),
        const SizedBox(height: 50),
        showEmailInput(emailController),
        const SizedBox(height: 25),
        showPasswordInput(passwordController),
        const SizedBox(height: 10),
        showForgotPassword(context),
        const SizedBox(height: 25),
        MyButton(
          onTap: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text)
                .whenComplete(() {
              Navigator.pop(context);
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
        Row(
          mainAxisAlignment: Platform.isIOS ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
          children: [
            showGoogleSignIn(),
            showAppleSignIn(),
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

  showIcon() {
    return const Image(
        image: AssetImage('lib/assets/images/chatXpress.png'), height: 100);
  }

  showEmailInput(TextEditingController emailController) {
    return MyTextfield(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        icon: Icons.email_outlined);
  }

  showPasswordInput(TextEditingController passwordController) {
    return MyTextfield(
        controller: passwordController,
        hintText: 'Password',
        obscureText: true,
        icon: Icons.lock_outline);
  }

  showForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
              color: MyColors.greenDefaultColorDark,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // To display the Apple Sign In, only for iOS.
  // If not iOS, then show SizedBox.shrink() -> like nothing, instead of null.
  showAppleSignIn() {
    if (Platform.isIOS) {
      return MySquareTile(
        imagePath: 'lib/assets/images/apple.png',
        onTap: () {
          AuthService().signInWithApple();
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  showGoogleSignIn() {
    return MySquareTile(
      imagePath: 'lib/assets/images/google.png',
      onTap: () {
        AuthService().signInWithGoogle();
      },
    );
  }
}
