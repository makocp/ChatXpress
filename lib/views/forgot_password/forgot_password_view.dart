import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/box_components/my_infobox.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ForgotPasswordView extends StatelessWidget with GetItMixin {
  ForgotPasswordView({super.key});

  final _emailController = TextEditingController();
  final _forgotPasswordViewmodel = serviceContainer<ForgotPasswordViewmodel>();

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        watchOnly((ForgotPasswordViewmodel vm) => vm.isLoading);
    final String errorMessage =
        watchOnly((ForgotPasswordViewmodel vm) => vm.errorMessage);
    final String successMessage =
        watchOnly((ForgotPasswordViewmodel vm) => vm.successMessage);
    bool isError() => errorMessage.isNotEmpty;

    // Absorbpointer true, only if loading -> no user interaction possible, to avoid bugs.
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: MyContainerSignInAndUp(listViewContent: [
          showEmailInput(isError()),
          isError()
              ? MyInfoBox(message: errorMessage, isError: true)
              : MyInfoBox(message: successMessage, isError: false),
          showResetPasswordButton(context, isLoading),
        ]),
      ),
    );
  }

  MyButton showResetPasswordButton(BuildContext context, bool isLoading) {
    return MyButton(
      onPressed: () => {
        _forgotPasswordViewmodel.handleResetInput(_emailController.text.trim())
      },
      buttonText: MyStrings.buttonResetPassword,
      isLoading: isLoading,
    );
  }

  MyTextfield showEmailInput(bool isError) {
    return MyTextfield(
        controller: _emailController,
        labelText: MyStrings.inputEmail,
        obscureText: false,
        isError: isError,
        icon: Icons.email_outlined);
  }
}
