import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/box_components/my_infobox.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/container_components/my_container_signinandup.dart';
import 'package:chatXpress/components/textfield_components/my_passwordfield.dart';
import 'package:chatXpress/components/textfield_components/my_textfield.dart';
import 'package:chatXpress/models/user_viewmodel.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/sign_up/sign_up_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SignUpView extends StatelessWidget with GetItMixin {
  SignUpView({super.key});

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _signUpViewmodel = serviceContainer<SignUpViewmodel>();
  late UserViewmodel userViewmodel;

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
          showUsernameInput(_usernameController, false),
          const SizedBox(height: 20),
          showEmailInput(_emailController, isErrorEmail()),
          isErrorEmail()
              ? MyInfoBox(message: messageEmail, isError: true)
              : const SizedBox(height: 20),
          showPasswordInput(_passwordController, isErrorPassword()),
          isErrorPassword()
              ? MyInfoBox(message: messagePassword, isError: true)
              : const SizedBox(height: 20),
          showConfirmationPasswordInput(
              _passwordConfirmationController, isErrorConfirmation()),
          isErrorConfirmation()
              ? MyInfoBox(message: messageConfirmation, isError: true)
              : const SizedBox(height: 20),
          const SizedBox(height: 20),
          showSignUpButton(context, isLoading),
          const SizedBox(height: 20),
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
    // validate Userinput
    return MyButton(
      onPressed: () => {
        // create a Userviewmodel for setting up an account and creating a user
        // in the database
        userViewmodel = UserViewmodel(
            email: _emailController.text,
            username: _usernameController.text,
            password: _passwordController.text),

        if (_signUpViewmodel.handleInput(_emailController.text.trim(),
            _passwordController.text, _passwordConfirmationController.text))
          {
            _signUpViewmodel
                .validateAndCreateUser(userViewmodel)
                .then((value) => {
                      _signUpViewmodel.signInWithEmailAndPassword(
                          userViewmodel.email, userViewmodel.password)
                    })
                .then((value) => {
                      _signUpViewmodel.resetValidation(),
                      Navigator.pop(context)
                    })
          }
      },
      buttonText: MyStrings.buttonSignUpCreate,
      isLoading: isLoading,
    );
  }

  MyPasswordfield showConfirmationPasswordInput(
      TextEditingController passwordConfirmationController, bool isError) {
    return MyPasswordfield(
        controller: passwordConfirmationController,
        labelText: MyStrings.inputConfirmPassword,
        isError: isError);
  }

  MyPasswordfield showPasswordInput(
      TextEditingController passwordController, bool isError) {
    return MyPasswordfield(
        controller: passwordController,
        labelText: MyStrings.inputPassword,
        isError: isError);
  }

  showEmailInput(TextEditingController emailController, bool isError) {
    return MyTextfield(
        controller: emailController,
        labelText: MyStrings.inputEmail,
        obscureText: false,
        isError: isError,
        icon: Icons.email_outlined);
  }

  showUsernameInput(TextEditingController usernameController, bool isError) {
    return MyTextfield(
        controller: usernameController,
        labelText: MyStrings.inputUsername,
        obscureText: false,
        isError: isError,
        icon: Icons.email_outlined);
  }
}
