
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// set the style(Color) of SystemNavigationBar to Black26
  void setSystemNavigationBarBlack26() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.black26,
      systemNavigationBarColor: Colors.black26
      )
    );
  }

  /// set the style(Color) of SystemNavigationBar to trasnparent
  void setSystemNavigationBarTransparent() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.black,
      systemNavigationBarColor: Colors.transparent
      )
    );
  }