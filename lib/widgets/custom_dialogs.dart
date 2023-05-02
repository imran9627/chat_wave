import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dialogs{

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  ShowCustomToast({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}