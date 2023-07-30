import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_button.dart';
import 'package:chatXpress/components/my_squaretile.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  signInUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greenDefaultColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Image(
                  image: AssetImage('lib/assets/images/chatXpress.png'),
                  height: 100),

              const SizedBox(height: 50),
              MyTextfield(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 25),
              MyTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      color: MyColors.greenDefaultColorDark,
                      fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 25),
              MyButton(
                onTap: signInUser,
              ),

              const SizedBox(height: 25),
              const Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Text(
                    'Or continue with',
                    style: TextStyle(color: MyColors.greenDefaultColorDark),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 25),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MySquareTile(imagePath: 'lib/assets/images/google.png'),
                  SizedBox(
                    width: 20,
                  ),
                  MySquareTile(imagePath: 'lib/assets/images/apple.png'),
                ],
              ),

              const SizedBox(height: 25,),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member? ', style: TextStyle(color: MyColors.greenDefaultColorDark),),
                  Text('Register now.', style: TextStyle(color: MyColors.greenDefaultColorDark, fontWeight: FontWeight.w600),)
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
