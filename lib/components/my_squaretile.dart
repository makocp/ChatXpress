import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MySquareTile extends StatelessWidget {
  final String imagePath;
  const MySquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.greenDefaultColorDark),
        color: MyColors.greenDefaultColorDark,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      // child: Card(
      //   elevation: 20,
      //   color: Colors.transparent,
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      // ),
    );
  }
}
