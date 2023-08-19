import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData icon;
  final bool isError;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.icon,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: borderColorUnfocused()),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: borderColor()),
          ),
          fillColor: Colors.white.withOpacity(0.8),
          filled: true,
          hintText: labelText,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }

  borderColor() {
    return isError ? Colors.red : Colors.white;
  }

  borderColorUnfocused() {
    return isError ? Colors.red : MyColors.greenDefaultColorDark;
  }
}
