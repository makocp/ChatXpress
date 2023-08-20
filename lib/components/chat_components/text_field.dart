import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomTextInput({super.key, 
    required this.hintText,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Card( // Wrap the Container with a Card
      elevation: 2, // Add the desired elevation for drop shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          keyboardType: TextInputType.text,
          controller: controller,
          onSubmitted: (value) {

          },
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
