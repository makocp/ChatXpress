import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/views/sign_up/sign_up_viewmodel.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _signUpViewmodel = SignUpViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(listViewContent: [
        showIcon(),
        const SizedBox(height: 50),
        showEmailInput(),
        const SizedBox(height: 25),
        showPasswordInput(),
        const SizedBox(height: 25),
        showConfirmationPasswordInput(),
        const SizedBox(height: 50),
        showSignUpButton(context),
        const SizedBox(height: 25),
        showSignInText(context)
      ]),
    );
  }

  Row showSignInText(BuildContext context) {
    return Row(
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
      );
  }

  MyButton showSignUpButton(BuildContext context) {
    return MyButton(
      onPressed: () => {
        if (_passwordController.text == _passwordConfirmationController.text)
          {
            _signUpViewmodel
                .signUp(_emailController.text, _passwordController.text)
                .then((value) =>
                    // This pop method is necessary to pop the SignUpPage and get to the HomePage.
                    // Otherwise the SignUpPage would "overwrite" the HomePage.
                    // -> See Widget Tree in Widget inspector for details and better understanding.
                    Navigator.pop(context))
          },
      },
      buttonText: 'Create Account',
    );
  }

  MyTextfield showConfirmationPasswordInput() {
    return MyTextfield(
        controller: _passwordConfirmationController,
        hintText: 'Confirm Password',
        obscureText: true,
        icon: Icons.lock_outline);
  }

  MyTextfield showPasswordInput() {
    return MyTextfield(
        controller: _passwordController,
        hintText: 'Password',
        obscureText: true,
        icon: Icons.lock_outline);
  }

  MyTextfield showEmailInput() {
    return MyTextfield(
        controller: _emailController,
        hintText: 'Email',
        obscureText: false,
        icon: Icons.email_outlined);
  }

  Image showIcon() {
    return const Image(
        image: AssetImage('assets/images/chatXpress.png'), height: 100);
  }
}
