import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';

class MessageCore {
  /// show an SnackBar
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ConfigSystemController.instance.isDarkTheme
          ? const Color.fromARGB(255, 17, 17, 17)
          : Colors.white,
      content: Text(
        msg,
        style: TextStyle(
            color: ConfigSystemController.instance.isDarkTheme
                ? Colors.white
                : Colors.black),
      ),
    ));
  }
  /// show an ToastMessage
  static void showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(192, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}