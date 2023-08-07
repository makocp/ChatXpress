import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_container_signinandup.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final emailController = TextEditingController();
  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MyContainerSignInAndUp(columnPageContent: [
        // Icon
        const Image(
            image: AssetImage('lib/assets/images/chatXpress.png'), height: 100),

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
            resetPassword(emailController.text).whenComplete(() {
              Navigator.pop(context);
            }),
          },
          buttonText: 'Reset Password',
        ),
      ]),
    );
  }

  resetPassword(String email) async {
    return await AuthService().resetPassword(email);
  }
}
