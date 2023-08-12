import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/pages/forgot_password/forgot_password_page_model.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
    ForgotPassword({super.key});

  final emailController = TextEditingController();

  final forgotPasswordPageModel = ForgotPasswordPageModel();

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

        // Email input
        const SizedBox(height: 50),
        MyTextfield(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            icon: Icons.email_outlined),
        const SizedBox(height: 20),
        MyButton(
          onTap: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            forgotPasswordPageModel.resetPassword(emailController.text).whenComplete(() {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
          },
          buttonText: 'Reset Password',
        ),
      ]),
    );
  }
}
