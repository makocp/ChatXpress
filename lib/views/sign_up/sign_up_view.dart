import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/views/sign_up/sign_up_viewmodel.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmationController = TextEditingController();

  final signUpPageModel = SignUpViewmodel();

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
        // Icon
        const Image(
            image: AssetImage('assets/images/chatXpress.png'), height: 100),

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
            if (passwordController.text ==
                passwordConfirmationController.text)
              {
                signUpPageModel.signUp(
                    context, emailController.text, passwordController.text)
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
