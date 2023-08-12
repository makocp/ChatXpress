import 'dart:io';
import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_squaretile.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/forgot_password/forgot_password_page.dart';
import 'package:chatXpress/pages/sign_in/sign_in_page_model.dart';
import 'package:chatXpress/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final signInPageModel = SignInPageModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
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
            signInPageModel.signInWithCredentials(
                context, emailController.text, passwordController.text)
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
            mainAxisAlignment: MainAxisAlignment.center,
            // To show Apple Sign In only on iOS device.
            children: Platform.isIOS
                ? [
                    showGoogleSignIn(),
                    const SizedBox(
                      width: 25,
                    ),
                    showAppleSignIn(),
                  ]
                : [
                    showGoogleSignIn(),
                  ]),
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
        image: AssetImage('assets/images/chatXpress.png'), height: 100);
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

  showAppleSignIn() {
    return MySquareTile(
      imagePath: 'assets/images/apple.png',
      onTap: () {
        signInPageModel.signInWithApple();
      },
    );
  }

  showGoogleSignIn() {
    return MySquareTile(
      imagePath: 'assets/images/google.png',
      onTap: () {
        signInPageModel.signInWithGoogle();
      },
    );
  }
}
