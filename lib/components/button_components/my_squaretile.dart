import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MySquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const MySquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Construct a Material Widget around the container for the Splash effect.
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      // To get the splash effect only inside the container.
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        // To change the ripple effect (longer duration), like in Elevated Button.
        splashFactory: InkRipple.splashFactory,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.transparent,
              border: Border.all(
                color: MyColors.greenDefaultColorDark,
              )),
          child: Image.asset(
            imagePath,
            height: 40,
          ),
        ),
      ),
    );
  }
}
