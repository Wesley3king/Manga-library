import 'package:flutter/material.dart';

class AboutPageController {
  final ValueNotifier<AboutPageStates> state =
      ValueNotifier<AboutPageStates>(AboutPageStates.home);
  /// configura a pagina a ser exibida
  set setPage(AboutPageStates value) {
    state.value = value;
  }
}

enum AboutPageStates {
  home,
  library,
  ocultLibrary,
  backup,
  extensions,
  updates
}
