import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/box_components/my_infobox.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/sign_up/sign_up_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SignUpView extends StatelessWidget with GetItMixin {
  SignUpView({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _signUpViewmodel = serviceContainer<SignUpViewmodel>();

  @override
  Widget build(BuildContext context) {
    final bool isLoading = watchOnly((SignUpViewmodel vm) => vm.isLoading);
    final String messageEmail =
        watchOnly((SignUpViewmodel vm) => vm.messageEmail);
    final String messagePassword =
        watchOnly((SignUpViewmodel vm) => vm.messagePassword);
    final String messageConfirmation =
        watchOnly((SignUpViewmodel vm) => vm.messageConfirmation);
    bool isErrorEmail() => messageEmail.isNotEmpty;
    bool isErrorPassword() => messagePassword.isNotEmpty;
    bool isErrorConfirmation() => messageConfirmation.isNotEmpty;

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
          showEmailInput(_emailController, isErrorEmail()),
          isErrorEmail()
              ? MyInfoBox(message: messageEmail, isError: true)
              : const SizedBox(height: 25),
          showPasswordInput(_passwordController, isErrorPassword()),
          isErrorPassword()
              ? MyInfoBox(message: messagePassword, isError: true)
              : const SizedBox(height: 25),
          showConfirmationPasswordInput(
              _passwordConfirmationController, isErrorConfirmation()),
          isErrorConfirmation()
              ? MyInfoBox(message: messageConfirmation, isError: true)
              : const SizedBox(height: 25),
          const SizedBox(height: 25),
          showSignUpButton(context, isLoading),
          const SizedBox(height: 25),
          showSignInText(context)
        ]),
      ),
    );
  }

  Row showSignInText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          MyStrings.signUpAlreadyMember,
          style: TextStyle(color: MyColors.greenDefaultColor),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            MyStrings.signUpSignInField,
            style: TextStyle(
                color: MyColors.greenDefaultColorDark,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  MyButton showSignUpButton(BuildContext context, bool isLoading) {
    return MyButton(
      onPressed: () => {
        _signUpViewmodel.handleInput(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _passwordConfirmationController.text.trim(), () => Navigator.pop(context))
      },
      buttonText: MyStrings.buttonSignUpCreate,
      isLoading: isLoading,
    );
  }

  MyTextfield showConfirmationPasswordInput(
      TextEditingController passwordConfirmationController, bool isError) {
    return MyTextfield(
        controller: passwordConfirmationController,
        labelText: MyStrings.inputConfirmPassword,
        obscureText: true,
        isError: isError,
        icon: Icons.lock_outline);
  }

  MyTextfield showPasswordInput(
      TextEditingController passwordController, bool isError) {
    return MyTextfield(
        controller: passwordController,
        labelText: MyStrings.inputPassword,
        obscureText: true,
        isError: isError,
        icon: Icons.lock_outline);
  }

  showEmailInput(TextEditingController emailController, bool isError) {
    return MyTextfield(
        controller: emailController,
        labelText: MyStrings.inputEmail,
        obscureText: false,
        isError: isError,
        icon: Icons.email_outlined);
  }
}
