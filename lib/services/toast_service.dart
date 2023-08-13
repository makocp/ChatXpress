import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  void showSuccessToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 16,
      backgroundColor: Colors.green);

  void showErrorToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 16,
      backgroundColor: Colors.red);

  void showWarningToast(String message) => Fluttertoast.showToast(
        msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 16,
      backgroundColor: Colors.yellow);
}
