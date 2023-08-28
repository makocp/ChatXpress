import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

class MyPasswordfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isError;

  const MyPasswordfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isError,
  });

  @override
  State<MyPasswordfield> createState() => _MyPasswordfieldState();
}

class _MyPasswordfieldState extends State<MyPasswordfield> {
  late bool showPassword;

  @override
  void initState() {
    showPassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: showPassword,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[700],
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
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
          hintText: widget.labelText,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }

  borderColor() {
    return widget.isError ? Colors.red : Colors.white;
  }

  borderColorUnfocused() {
    return widget.isError ? Colors.red : MyColors.greenDefaultColorDark;
  }
}
