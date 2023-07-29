import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greenDefaultColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage('lib/assets/images/chatXpress.png'), height: 100),
              const SizedBox(height: 25),
              const Text("Welcome back!"),
              const SizedBox(height: 25),
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
                child: Text('Forgot password?'),
              ),

        
              // sign in button
        
              // or continue with
        
              // google / apple sign in buttons
        
              // Not a member? register now, click here.
            ],
          ),
        ),
      ),
    );
  }
}
