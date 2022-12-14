import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/controllers/system_config.dart';
// import 'package:flutter/material.dart';

class FullScreenController {
  // static FullScreenTypes activedFullScreen = FullScreenTypes.home;

  // setFullScreen() {
  //   print('configurando...');

  //   if (isFullScreen) {
  //     exitEdgeFullScreen();
  //   } else {
  //     enterFullScreen();
  //   }
  // }

  Future<void> startScreenApp() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,

      // systemNavigationBarColor: Color.fromARGB(0, 0, 0, 0),
      // systemNavigationBarDividerColor: Color.fromARGB(0, 0, 0, 0),
      // systemNavigationBarIconBrightness: Brightness.light,
      // systemNavigationBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent
    ));
  }
  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void enterEdgeFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemStatusBarContrastEnforced: false,
    //   systemNavigationBarColor: Color.fromARGB(0, 0, 0, 0),
    //   systemNavigationBarDividerColor: Color.fromARGB(0, 0, 0, 0),
    //   systemNavigationBarContrastEnforced: false,
    // ));
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // statusBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.black26,
        systemNavigationBarColor: Colors.black26));
    // isFullScreen = false;
  }

  void exitEdgeFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(0, 0, 0, 0),
      systemNavigationBarDividerColor: Color.fromARGB(0, 0, 0, 0),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ));
  }

  void exitEdgeFullScreenToReader() {
    const Color color = Color.fromARGB(255, 24, 24, 24);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: color,
        systemNavigationBarColor: color));
    // isFullScreen = false;
  }

  // ==========================================================================
  //                      STYLES
  // ==========================================================================

  /// set the style(Color) of SystemNavigationBar to black26
  void setSystemNavigationBarBlack26() async {
    debugPrint("visivel!");
    /*
    ConfigSystemController.instance.isDarkTheme ? 
    */
    SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.black26,
        systemNavigationBarColor: Colors.black26));
  }

  /// set the style(Color) of SystemNavigationBar to white24
  void setSystemNavigationBarWhite24() async {
    debugPrint("visivel!");
    SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white24,
        systemNavigationBarColor: Colors.white24));
  }

  /// set the style(Color) of SystemNavigationBar to trasnparent
  void setSystemNavigationBarTransparent() async {
    debugPrint("invisivel!");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: ConfigSystemController.instance.isDarkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent
    ));
  }
}

// enum FullScreenTypes { home ,mangaDetail, reader}