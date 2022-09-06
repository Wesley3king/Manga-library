import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/settings_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/seetings_model.dart';

class SettingsOptionsController {
  final SettingsController _settingsController = SettingsController();
  List<Settings> settings = [];
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
      print(GlobalData.settings);
      getAtualTypeSelected(type);
      state.value = SettingsOptionsStates.sucess;
    } catch (e, s) {
      print("error no start - SettingsOptionsController: $e");
      print(s);
      state.value = SettingsOptionsStates.error;
    }
  }

  getAtualTypeSelected(String type) {
    for (int i = 0; i < GlobalData.settingsApp.data.length; ++i) {
      Data data = GlobalData.settingsApp.data[i];
      if (data.type == type) {
        settings = data.settings;
        titleType = data.nameOptions;
        break;
      }
    }
  }

  updateSetting() {
    state.value = SettingsOptionsStates.update;
    start(updateType);
  }
}

enum SettingsOptionsStates { start, loading, sucess, update, error }
