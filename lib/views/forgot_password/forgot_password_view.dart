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
        showEmailInput(),
        const SizedBox(height: 20),
        showResetPasswordButton(context),
      ]),
    );
  }

  MyButton showResetPasswordButton(BuildContext context) {
    return MyButton(
      onPressed: () => {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        _forgotPasswordViewmodel
            .resetPassword(_emailController.text)
            // This pop is on success, to get to the SignInView.
            .then((value) => {Navigator.pop(context)})
            // This pop needs to be done on success or failure, to pop the progress indicator.
            .whenComplete(() => Navigator.pop(context)),
      },
      buttonText: 'Reset Password',
    );
  }

  MyTextfield showEmailInput() {
    return MyTextfield(
        controller: _emailController,
        hintText: 'Email',
        obscureText: false,
        icon: Icons.email_outlined);
  }
}
