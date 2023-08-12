import 'dart:io';
import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/button_components/my_squaretile.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/views/forgot_password/forgot_password_view.dart';
import 'package:chatXpress/views/sign_in/sign_in_viewmodel.dart';
import 'package:chatXpress/views/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final signInPageModel = SignInViewmodel();

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
                    MaterialPageRoute(builder: (context) => const SignUpView()));
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
              MaterialPageRoute(builder: (context) => ForgotPasswordView()));
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
