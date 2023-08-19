import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyInfoBox extends StatelessWidget {
  final String message;
  final bool isError;
  const MyInfoBox({super.key, required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 2),
        child: Row(
          children: [
            Text(
              message,
              style: showTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  showTextStyle() {
    return isError
        ? const TextStyle(color: Colors.red, fontSize: 12)
        : const TextStyle(
            color: MyColors.greenDefaultColorDark,
            fontSize: 12,
            fontWeight: FontWeight.bold);
  }
}
