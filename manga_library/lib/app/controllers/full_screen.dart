import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';

class FullScreenController {
  static bool isFullScreen = false;

  setFullScreen() {
    print('configurando...');

    if (isFullScreen) {
      exitFullScreen();
    } else {
      enterFullScreen();
    }
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]);
    isFullScreen = true;
  }

  void enterEdgeFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Color.fromARGB(0, 0, 0, 0),
        systemNavigationBarDividerColor: Color.fromARGB(0, 0, 0, 0),
        systemNavigationBarContrastEnforced: false,
        ));
    isFullScreen = false;
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     systemStatusBarContrastEnforced: true,
    //     systemNavigationBarDividerColor: Color.fromARGB(255, 0, 0, 0),
    //     systemNavigationBarContrastEnforced: true,
    //     ));
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarDividerColor: Colors.black26,
          systemNavigationBarColor: Colors.black26));
    isFullScreen = false;
  }
}
