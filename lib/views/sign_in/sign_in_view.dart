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
    final bool isLoading = watchOnly((SignInViewmodel vm) => vm.isLoading);
    final String emailErrorMessage =
        watchOnly((SignInViewmodel vm) => vm.emailErrorMessage);
    final String passwordErrorMessage =
        watchOnly((SignInViewmodel vm) => vm.passwordErrorMessage);
    bool isErrorEmail() => emailErrorMessage.isNotEmpty;
    bool isErrorPassword() => passwordErrorMessage.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(listViewContent: [
        showEmailInput(_emailController, isErrorEmail()),
        isErrorEmail()
            ? showErrorBox(emailErrorMessage)
            : const SizedBox(height: 25),
        showPasswordInput(_passwordController, isErrorPassword()),
        isErrorPassword()
            ? showErrorBox(passwordErrorMessage)
            : const SizedBox(height: 25),
        showSignInButton(isLoading, context),
        const SizedBox(height: 10),
        showForgotPassword(context, isLoading),
        const SizedBox(height: 25),
        showDivider(),
        const SizedBox(height: 25),
        showAlternativeSignIn(isLoading),
        const SizedBox(height: 25),
        showRegisterText(context, isLoading),
      ]),
    );
  }

  showErrorBox(String errorMessage) {
    return SizedBox(
      height: 25,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 2),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }

  Row showRegisterText(BuildContext context, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Not a member? ',
          style: TextStyle(color: MyColors.greenDefaultColorDark),
        ),
        GestureDetector(
          onTap: () {
            if (!isLoading) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpView()));
            }
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

  Row showAlternativeSignIn(bool isLoading) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // To show Apple Sign In only on iOS device.
        children: Platform.isIOS
            ? [
                showGoogleSignIn(isLoading),
                const SizedBox(
                  width: 25,
                ),
                showAppleSignIn(isLoading),
              ]
            : [
                showGoogleSignIn(isLoading),
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

  showSignInButton(bool isLoading, BuildContext context) {
    return isLoading
        ? const MyButtonLoading()
        : MyButton(
            onPressed: () => {
              if (!isLoading)
                {
                  _signInViewmodel.signInAndSetToDb(
                      _emailController.text.trim(),
                      _passwordController.text.trim()),
                }
            },
            buttonText: 'Login',
          );
  }

  showEmailInput(TextEditingController emailController, bool isErrorEmail) {
    return MyTextfield(
        controller: emailController,
        labelText: 'Email',
        obscureText: false,
        isError: isErrorEmail,
        icon: Icons.email_outlined);
  }

  showPasswordInput(
      TextEditingController passwordController, bool isErrorPassword) {
    return MyTextfield(
        controller: passwordController,
        labelText: 'Password',
        obscureText: true,
        isError: isErrorPassword,
        icon: Icons.lock_outline);
  }

  Align showForgotPassword(BuildContext context, bool isLoading) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPasswordView()));
          }
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

  MySquareTile showAppleSignIn(bool isLoading) {
    return MySquareTile(
      imagePath: 'assets/images/apple.png',
      onTap: () {
        if (!isLoading) {
          _signInViewmodel.signInWithApple();
        }
      },
    );
  }

  MySquareTile showGoogleSignIn(bool isLoading) {
    return MySquareTile(
      imagePath: 'assets/images/google.png',
      onTap: () {
        if (!isLoading) {
          _signInViewmodel.signInWithGoogle();
        }
      },
    );
  }
}
