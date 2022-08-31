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
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]
    );
    isFullScreen = true;
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
    isFullScreen = false;
  }
}
