import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/settings_model.dart';
import 'package:manga_library/app/models/system_settings.dart';
import 'package:manga_library/app/views/configurations/config_pages/controller/generate_model.dart';

class SettingsController {
  final HiveController hiveController = HiveController();
  final GlobalData _globalData = GlobalData();
  SettingsModel settings = SettingsModel(models: []);

  Future start() async {
    SystemSettingsModel data = await hiveController.getSettings();
    try {
      GlobalData.settingsApp = buildSettingsModel();
    } catch (e, s) {
      debugPrint('erro no buildSettings: $e');
      debugPrint('$s');
    }
  }
}
class SettingsOptionsController {
  final SettingsController _settingsController = SettingsController();
  List<dynamic> settingsAndContainers = [];
  String titleType = "";
  String updateType = "";
  ValueNotifier<SettingsOptionsStates> state =
      ValueNotifier<SettingsOptionsStates>(SettingsOptionsStates.start);

  start(String type) async {
    state.value = SettingsOptionsStates.loading;
    updateType = type;
    try {
      await _settingsController.start();
      //print("chegou aqui!!");
      debugPrint('${GlobalData.settings}');
      getAtualTypeSelected(type);
      state.value = SettingsOptionsStates.sucess;
    } catch (e, s) {
      debugPrint("error no start - SettingsOptionsController: $e");
      debugPrint('$s');
      state.value = SettingsOptionsStates.error;
    }
  }

  getAtualTypeSelected(String type) {
    for (int i = 0; i < GlobalData.settingsApp.models.length; ++i) {
      ConfigurationModel data = GlobalData.settingsApp.models[i];
      if (data.type == type) {
        settingsAndContainers = data.settings;
        titleType = data.nameOptions;
        break;
      }
    }
  }

  updateSetting() {
    state.value = SettingsOptionsStates.update;
    start(updateType);
    debugPrint("settings updated!");
  }
}

enum SettingsOptionsStates { start, loading, sucess, update, error }
