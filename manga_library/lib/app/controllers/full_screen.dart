import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';

class FullScreenController {
  static FullScreenTypes activedFullScreen = FullScreenTypes.home;

  // setFullScreen() {
  //   print('configurando...');

  //   if (isFullScreen) {
  //     exitEdgeFullScreen();
  //   } else {
  //     enterFullScreen();
  //   }
  // }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]);
    // activedFullScreen
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
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.black26,
        systemNavigationBarColor: Colors.black26));
    // isFullScreen = false;
  }

  void exitEdgeFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Color.fromARGB(0, 0, 0, 0),
      systemNavigationBarDividerColor: Color.fromARGB(0, 0, 0, 0),
      systemNavigationBarContrastEnforced: false,
    ));
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     systemNavigationBarContrastEnforced: false,
    //     systemNavigationBarDividerColor: Colors.black26,
    //     systemNavigationBarColor: Colors.black26));
    // isFullScreen = false;
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
}

enum FullScreenTypes { home ,mangaDetail, reader}