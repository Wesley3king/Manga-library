class SettingsModel {
  SettingsModel({
    required this.data,
  });
  late final List<Data> data;

  SettingsModel.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.type,
    required this.nameOptions,
    required this.settings,
  });
  late final String type;
  late final String nameOptions;
  late final List<Settings> settings;

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    nameOptions = json['nameOptions'];
    settings =
        List.from(json['settings']).map((e) => Settings.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['nameOptions'] = nameOptions;
    _data['settings'] = settings.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Settings {
  Settings({
    required this.nameConfig,
    required this.description,
    required this.inputType,
    required this.value,
    required this.function,
    required this.optionsAndValues,
  });
  late final String nameConfig;
  late final String description;
  late final String inputType;
  late final dynamic value;
  late final Function function;
  late final List<OptionsAndValues> optionsAndValues;

  Settings.fromJson(Map<String, dynamic> json) {
    nameConfig = json['nameConfig'];
    description = json['description'];
    inputType = json['inputType'];
    value = json['value'];
    print(json['function'] is Function
        ? "${json['nameConfig']} true"
        : "${json['nameConfig']} false");
    function = json['function'];
    optionsAndValues = List.from(json['optionsAndValues'])
        .map((e) => OptionsAndValues.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nameConfig'] = nameConfig;
    _data['description'] = description;
    _data['inputType'] = inputType;
    _data['value'] = value;
    _data['function'] = function;
    _data['optionsAndValues'] =
        optionsAndValues.map((e) => e.toJson()).toList();
    return _data;
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
    final _data = <String, dynamic>{};
    _data['option'] = option;
    _data['value'] = value;
    return _data;
  }
}
