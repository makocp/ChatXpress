import 'dart:io';
import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/button_components/my_button_loading.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/button_components/my_squaretile.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/forgot_password/forgot_password_view.dart';
import 'package:chatXpress/views/sign_in/sign_in_viewmodel.dart';
import 'package:chatXpress/views/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SignInView extends StatelessWidget with GetItMixin {
  SignInView({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInViewmodel = serviceContainer<SignInViewmodel>();

  @override
  Widget build(BuildContext context) {
    // to show the progress indicator
    final bool isLoading = watchOnly((SignInViewmodel x) => x.isLoading);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(listViewContent: [ 
        showEmailInput(_emailController),
        const SizedBox(height: 25),
        showPasswordInput(_passwordController),
        const SizedBox(height: 10),
        showForgotPassword(context),
        const SizedBox(height: 25),
        showSignInButton(isLoading),
        const SizedBox(height: 25),
        showDivider(),
        const SizedBox(height: 25),
        showAlternativeSignIn(),
        const SizedBox(height: 25),
        showRegisterText(context)
      ]),
    );
  }

  Row showRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Not a member? ',
          style: TextStyle(color: MyColors.greenDefaultColorDark),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpView()));
          },
          child: const Text(
            'Create account.',
            style: TextStyle(
                color: MyColors.greenDefaultColorDark,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Row showAlternativeSignIn() {
    return Row(
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
              ]);
  }

  Row showDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Text(
          'Or continue with',
          style: TextStyle(color: MyColors.greenDefaultColorDark),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  showSignInButton(bool isLoading) {
    return isLoading ? const MyButtonLoading() : MyButton(
      onPressed: () => {
        _signInViewmodel.signInAndSetToDb(
            _emailController.text, _passwordController.text),
      },
      buttonText: 'Login',
    );
  }

  MyTextfield showEmailInput(TextEditingController emailController) {
    return MyTextfield(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        icon: Icons.email_outlined);
  }

  MyTextfield showPasswordInput(TextEditingController passwordController) {
    return MyTextfield(
        controller: passwordController,
        hintText: 'Password',
        obscureText: true,
        icon: Icons.lock_outline);
  }

  Align showForgotPassword(BuildContext context) {
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

  MySquareTile showAppleSignIn() {
    return MySquareTile(
      imagePath: 'assets/images/apple.png',
      onTap: () {
        _signInViewmodel.signInWithApple();
      },
    );
  }

  MySquareTile showGoogleSignIn() {
    return MySquareTile(
      imagePath: 'assets/images/google.png',
      onTap: () {
        _signInViewmodel.signInWithGoogle();
      },
    );
  }
}
