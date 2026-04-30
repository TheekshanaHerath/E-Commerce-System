import 'package:flutter/material.dart';

class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void success(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
    );
  }
}