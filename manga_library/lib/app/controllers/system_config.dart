import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:permission_handler/permission_handler.dart';

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
    debugPrint('$data');
    GlobalData.settings = data;
    ConfigSystemController.instance.start();
  }

  getSystemPermissions() async {
    final FileManager fileManager = FileManager();
    PermissionStatus permissionStorageStatus = PermissionStatus.denied;
    PermissionStatus permissionManageStatus = PermissionStatus.denied;
    // storage permission
    permissionStorageStatus = await Permission.storage.status;
    // print(_permissionReadStatus.isDenied ? "não TEM PERMISÃO" : "ta ok");
    if (permissionStorageStatus != PermissionStatus.granted) {
      log("fazendo a requisição do read");
      permissionStorageStatus = await Permission.storage.request();
    }
    // storage management android 11
    permissionManageStatus = await Permission.manageExternalStorage.status;
    if (permissionManageStatus != PermissionStatus.granted) {
      log("fazendo a requisição do write");
      permissionManageStatus = await Permission.manageExternalStorage.request();
    }

    // cria a estrutra de pastas do aplicativo
    if (permissionStorageStatus == PermissionStatus.granted ||
        permissionManageStatus == PermissionStatus.granted) {
      await fileManager.verifyIfIsFirstTime();
    }
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

  Color colorManagement() {
    // print(GlobalData.settings['Cor da Interface']);
    switch (GlobalData.settings['Cor da Interface']) {
      case "blue":
        return const Color.fromARGB(255, 40, 152, 243);
      case "green":
        return const Color.fromARGB(255, 87, 223, 91);
      case "lime":
        return Colors.lime;
      case "purple":
        return const Color.fromARGB(255, 169, 47, 190);
      case "pink":
        return Colors.pink;
      case "cleanpink":
        return const Color.fromARGB(255, 213, 91, 235);
      case "orange":
        return Colors.orange;
      case "red":
        return Colors.red;
      case "black":
        return Colors.black;
      case "white":
        return Colors.white;
      case "grey":
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void setSystemOrientacion(String orientacion) {
    switch (orientacion) {
      case "auto":
        SystemChrome.setPreferredOrientations([]);
        break;
      case "portraitup":
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        break;
      case "portraitdown":
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
        break;
      case "landscapeleft":
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
        break;
      case "landscaperight":
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
        break;
    }
  }
}
