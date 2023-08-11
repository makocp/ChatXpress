import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/sign_up/sign_up_page_model.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmationController = TextEditingController();

  late SignUpPageModel signUpPageModel;

  @override
  void initState() {
    registerSignUpService();
    signUpPageModel = ServiceLocator<SignUpPageModel>();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        unregisterSignUpService();
        return true;
      },
      child: Scaffold(
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
              if (passwordController.text == passwordConfirmationController.text)
                {
                  signUpPageModel.signUp(context,emailController.text,passwordController.text)
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
                  unregisterSignUpService();
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
      ),
    );
  }
}
