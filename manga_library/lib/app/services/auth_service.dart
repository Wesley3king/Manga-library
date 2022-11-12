import 'package:flutter/material.dart';
import 'package:manga_library/app/models/globais.dart';

class AuthService extends ChangeNotifier {
  bool isAuthenticated = false;
  
  bool login(dynamic value) {
    if (value.toString() == GlobalData.settings.authenticationPassword) {
      isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
