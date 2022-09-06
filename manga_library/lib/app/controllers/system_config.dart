import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../models/globais.dart';

class SystemController {
  final HiveController _hiveController = HiveController();
  Future start() async {
    // inicializar o Hive
    await _hiveController.start();
    updateConfig();
  }

  Future updateConfig() async {
    Map data = await _hiveController.getSettings();
    print(data);
    GlobalData.settings = data;
    ConfigSystemController.instance.start();
  }
}

class ConfigSystemController extends ChangeNotifier {
  final HiveController _hiveController = HiveController();
  static ConfigSystemController instance = ConfigSystemController();

  start() {
    notifyListeners();
  }

  update(Map data) async {
    final SystemController systemController = SystemController();
    bool response = await _hiveController.updateSettings(data);
    if (response) systemController.updateConfig();
  }
}
