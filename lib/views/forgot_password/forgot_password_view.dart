import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/views/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
    ForgotPasswordView({super.key});

  final _emailController = TextEditingController();
  final _forgotPasswordViewmodel = ForgotPasswordViewmodel();

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
        // Email input
        const SizedBox(height: 50),
        MyTextfield(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
            icon: Icons.email_outlined),
        const SizedBox(height: 20),
        MyButton(
          onPressed: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            _forgotPasswordViewmodel.resetPassword(_emailController.text).whenComplete(() {
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
