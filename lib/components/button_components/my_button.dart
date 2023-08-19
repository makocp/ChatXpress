import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isLoading;

  const MyButton(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.greenDefaultColor,
          padding: const EdgeInsets.all(15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        child: showButtonContent(),
      ),
    );
  }

  showButtonContent() {
    return isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )
        : Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          );
  }
}
