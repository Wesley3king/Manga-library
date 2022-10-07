class SettingsModel {
  late final List<ConfigurationModel> models;

  SettingsModel({required this.models});

  SettingsModel.fromJson() {}

  toJson() {}
}

class ConfigurationModel {
  late final String type;
  late final String nameOptions;
  late final List<dynamic> settings;

  ConfigurationModel(
      {required this.nameOptions, required this.type, required this.settings});

  ConfigurationModel.fromJson() {}

  toJson() {}
}

abstract class ConfigContainers {
  late final String type;
  late final List<dynamic> settings;

  ConfigContainers({required this.type, required this.settings});
}

class SettingsContainer extends ConfigContainers {
  SettingsContainer({required super.settings, required super.type});
}

class SettingsDependence extends ConfigContainers {
  SettingsDependence({required super.settings, required super.type});
}

class SettingsClass extends ConfigContainers {
  late final String nameClass;
  SettingsClass(
      {required super.settings, required super.type, required this.nameClass});
}

class Setting {
  late final String nameConfig;
  late final String description;
  late final String inputType;
  late dynamic value;
  late final Map<String, dynamic> optionsAndValues;

  Setting({required this.nameConfig, required this.description, required this.inputType, required this.value, required this.optionsAndValues});

  Setting.fromJson(Map<String, dynamic> json) {}
}
{
            "nameConfig": "Tamanho dos quadros",
            "description": "Configura o tamanho das capas",
            "inputType": "switch",
            "value": "normal",
            "optionsAndValues": [
                {"option": "Pequenos", "value": "small"},
                {"option": "Normal", "value": "normal"},
                {"option": "Grandes", "value": "big"}
                ]
            },
