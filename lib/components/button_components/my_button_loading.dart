import 'package:flutter/material.dart';

import '../../assets/colors/my_colors.dart';

class MyButtonLoading extends StatelessWidget {
  const MyButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.greenDefaultColor,
              padding: const EdgeInsets.all(15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
          child: const SizedBox(
            height: 20,
            width: 20,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )),
    );
  }
}
