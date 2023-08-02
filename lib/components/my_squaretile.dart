import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MySquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const MySquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: MyColors.greenDefaultColorDark,
          )
        ),
        // child: Card(
        //   elevation: 20,
        //   color: Colors.transparent,
          child: Image.asset(
            imagePath,
            height: 40,
          ),
        // ),
      ),
    );
  }
}
