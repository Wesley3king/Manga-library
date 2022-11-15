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

  /// set the style(Color) of SystemNavigationBar to white24
  static void setSystemNavigationBarWhite24() async {
    // debugPrint("invisivel!");
    fullScreenController.setSystemNavigationBarWhite24();
  }

  /// if true statusBar is Transparent
  // static void toggleStatusBarContrastEnforced(bool value) {
  //   value ?
  //   fullScreenController.enterStatusBarForDetailsPage() :
  //   fullScreenController.exitStatusBarForDetailsPage();
  // }
}
