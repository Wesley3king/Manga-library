// import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';

class StylesFromSystemNavigation {
  static FullScreenController fullScreenController = FullScreenController();

  /// set the style(Color) of SystemNavigationBar to Black26
  static void setSystemNavigationBarBlack26() async {
    // debugPrint("visivel!");
    fullScreenController.setSystemNavigationBarBlack26();
  }

  /// set the style(Color) of SystemNavigationBar to trasnparent
  static void setSystemNavigationBarTransparent() async {
    // debugPrint("invisivel!");
    fullScreenController.setSystemNavigationBarTransparent();
  }
}
