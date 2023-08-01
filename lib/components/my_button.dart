import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Function()? onTap;
  final String buttonText;
  const MyButton({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            // color: Colors.black,
            color: MyColors.greenDefaultColorDark,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Center(
            child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )),
      ),
    );
  }
}
