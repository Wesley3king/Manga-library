import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class FullScreenController {
  static bool isFullScreen = false;

  setFullScreen() {
    isFullScreen = !isFullScreen;
    print('configurando...');

    if (isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black26,
    //   statusBarIconBrightness: Brightness.dark,
    // ));
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  }
}
