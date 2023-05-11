import 'package:flutter/material.dart';


class Dialogs{

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

}