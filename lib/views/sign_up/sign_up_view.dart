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
            _signUpViewmodel.createAccountAndSignIn(_emailController.text,
                _passwordController.text, _popView)
          },
      },
      buttonText: 'Create Account',
    );
  }

  void _popView() {
    Navigator.pop(context);
  }

  MyTextfield showConfirmationPasswordInput() {
    return MyTextfield(
        controller: _passwordConfirmationController,
        labelText: 'Confirm Password',
        obscureText: true,
        isError: false,
        icon: Icons.lock_outline);
  }

  MyTextfield showPasswordInput() {
    return MyTextfield(
        controller: _passwordController,
        labelText: 'Password',
        obscureText: true,
        isError: false,
        icon: Icons.lock_outline);
  }

  MyTextfield showEmailInput() {
    return MyTextfield(
        controller: _emailController,
        labelText: 'Email',
        obscureText: false,
        isError: false,
        icon: Icons.email_outlined);
  }
}
