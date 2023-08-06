import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTap; // Changed Function()? to VoidCallback?
  final String buttonText;

  const MyButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // Changed onTap to onPressed
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.greenDefaultColor,
        padding: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          // fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
