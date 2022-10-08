import 'package:flutter/material.dart';

class SettingsModel {
  late final List<ConfigurationModel> models;

  SettingsModel({required this.models});

  SettingsModel.fromJson(List<Map<String, dynamic>> jsons) {
    models = jsons
        .map<ConfigurationModel>((e) => ConfigurationModel.fromJson(e))
        .toList();
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> data = models.map((e) => e.toJson()).toList();
    return data;
  }
}

class ConfigurationModel {
  late final String type;
  late final String nameOptions;
  late final List<dynamic> settings;

  ConfigurationModel(
      {required this.nameOptions, required this.type, required this.settings});

  ConfigurationModel.fromJson(Map<String, dynamic> json) {
    // debugPrint("chefou ao ConfigurationModel.fromJson! - model: $json");
    type = json['type'];
    nameOptions = json['nameOptions'];
    settings = List.from(json['settings']).map((e) {
      if (e['type'] == "container") {
        return SettingsContainer.fromJson(e);
      } else if (e['type'] == "dependence") {
        return SettingsDependence.fromJson(e);
      } else if (e['type'] == "class") {
        return SettingsClass.fromJson(e);
      } else {
        return Setting.fromJson(e);
      }
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['nameOptions'] = nameOptions;
    data['settings'] = settings.map((e) => e.toJson()).toList();
    return data;
  }
}

// abstract class ConfigContainers {
//   late final String type;
//   late final List<dynamic> settings;

//   ConfigContainers({required this.type, required this.settings});
// }

class SettingsContainer {
  late final String type;
  late final List<dynamic> children;
  //  extends ConfigContainers
  SettingsContainer({required this.children, required this.type});

  SettingsContainer.fromJson(Map<String, dynamic> json) {
    type = "container";
    children = List.from(json['children']).map((e) {
      if (e is Widget) {
        return e;
      } else {
        return Setting.fromJson(e);
      }
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['children'] = children.map((e) {
      if (e is Widget) {
        return e;
      } else {
        return e.toJson();
      }
    }).toList();
    return data;
  }
}

class SettingsDependence {
  late final String type;
  late final List<dynamic> children;
  SettingsDependence({required this.children, required this.type});

  SettingsDependence.fromJson(Map<String, dynamic> json) {
    type = "dependence";
    children = List.from(json['children']).map((e) {
      if (e['type'] == "container") {
        return SettingsContainer.fromJson(e);
      } else {
        return Setting.fromJson(e);
      }
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['children'] = children.map((e) => e.toJson()).toList();
    return data;
  }
}

class SettingsClass {
  late final String type;
  late final List<dynamic> children;
  late final String nameClass;
  SettingsClass(
      {required this.children, required this.type, required this.nameClass});

  SettingsClass.fromJson(Map<String, dynamic> json) {
    type = "class";
    children = List.from(json['children']).map((e) {
      if (e['type'] == "dependence") {
        return SettingsDependence.fromJson(e);
      } else if (e['type'] == "container") {
        return SettingsContainer.fromJson(e);
      } else {
        return Setting.fromJson(e);
      }
    }).toList();
    nameClass = json['nameClass'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['nameClass'] = nameClass;
    data['children'] = children.map((e) => e.toJson()).toList();
    return data;
  }
}

class Setting {
  late final String type;
  late final String nameConfig;
  late final String description;
  // late final String inputType;
  late dynamic value;
  late Function function;
  late final List<OptionsAndValues> optionsAndValues;

  Setting(
      {required this.type,
      required this.nameConfig,
      required this.description,
      // required this.inputType,
      required this.value,
      required this.optionsAndValues,
      required this.function});

  Setting.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    nameConfig = json['nameConfig'];
    description = json['description'];
    // inputType = json['inputType'];
    function = json['function'];
    value = json['value'];
    optionsAndValues = List.from(json['optionsAndValues'])
        .map((e) => OptionsAndValues.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['nameConfig'] = nameConfig;
    data['description'] = description;
    // data['inputType'] = inputType;
    data['value'] = value;
    data['function'] = function;
    data['optionsAndValues'] = optionsAndValues.map((e) => e.toJson()).toList();
    return data;
  }
}

class OptionsAndValues {
  OptionsAndValues({
    required this.option,
    required this.value,
  });
  late final String option;
  late final dynamic value;

  OptionsAndValues.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['option'] = option;
    data['value'] = value;
    return data;
  }
}
