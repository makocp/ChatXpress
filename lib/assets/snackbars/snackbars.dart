import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:flutter/material.dart';

class MySnackBars {
  static bool snackbarActive = false;

  static void showSnackBar(BuildContext context, SnackBar snackBar) {
    if (!snackbarActive) {
      snackbarActive = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar)
          .closed
          .then((value) => {snackbarActive = false});
    }
  }

  static SnackBar ongoingRequest = const SnackBar(
    content: Text(MyStrings.onGoingRequest),
  );
}
