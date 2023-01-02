import 'package:flutter/rendering.dart';
import 'package:manga_library/app/views/configurations/config_pages/controller/page_config_controller.dart';
import 'package:system_settings/system_settings.dart';

import '../../../../controllers/system_config.dart';
import '../../../../models/globais.dart';

var settings = GlobalData.settings;

Map<String, Function> settingsFunctions = {
  "Ordenação": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Ordenação: $value");
    GlobalData.settings.ordination = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tamanho dos quadros": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Tamanho dos quadros: $value");
    GlobalData.settings.frameSize = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Atualizar": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Atualizar: $value");
    GlobalData.settings.update = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Atualizar as Capas": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Tamanho dos quadros: $value");
    GlobalData.settings.updateTheCovers = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Senha da Biblioteca Oculta":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor deSenha da Biblioteca Oculta: $value");
    GlobalData.settings.hiddenLibraryPassword = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tema": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.theme = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Cor da Interface": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.interfaceColor = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Idioma": (dynamic value, SettingsOptionsController controller) {},
  "Rolar a Barra": (dynamic value, SettingsOptionsController controller) {
    GlobalData.settings.rollTheBar = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tipo do Leitor": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.readerType = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Cor de fundo": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor Cor de fundo = $value");
    GlobalData.settings.backgroundColor = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Orientação do Leitor":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.readerGuidance = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Qualidade": (dynamic value, SettingsOptionsController controller) {
    GlobalData.settings.quality = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tela cheia": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de Tela cheia: $value");
    GlobalData.settings.fullScreen = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Manter a tela ligada":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de Manter a tela ligada: $value");
    GlobalData.settings.keepScreenOn = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "ShowControls": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de ShowControls: $value");
    GlobalData.settings.showControls = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Custom Shine": (dynamic value, SettingsOptionsController? controller) {
    debugPrint("valor de Custom Shine: $value");
    GlobalData.settings.customShine = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller?.updateSetting();
  },
  "Custom Shine Value": (dynamic value) {
    debugPrint("valor de Custom Shine Value: $value");
    GlobalData.settings.customShineValue = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
  },
  "Custom Filter": (dynamic value, SettingsOptionsController? controller) {
    debugPrint("valor de Custom Filter: $value");
    GlobalData.settings.customFilter = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller?.updateSetting();
  },
  "Custom Filter Values": (int value, String type) {
    // debugPrint("valor de Custom Shine Value: $value");
    switch (type) {
      case "R":
        GlobalData.settings.R = value;
        break;
      case "G":
        GlobalData.settings.G = value;
        break;
      case "B":
        GlobalData.settings.B = value;
        break;
    }
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
  },
  "Black and White filter":
      (dynamic value, SettingsOptionsController? controller) {
    debugPrint("valor de Black and White filter: $value");
    GlobalData.settings.blackAndWhiteFilter = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller?.updateSetting();
  },
  "Layout": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de Layout: $value");
    GlobalData.settings.layout = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "ShowLayout": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de ShowLayout: $value");
    GlobalData.settings.showLayout = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "ScrollWebtoon": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de ScrollWebtoon: $value");
    GlobalData.settings.scrollWebtoon = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Local de armazenamento":
      (dynamic value, SettingsOptionsController controller) {},
  "Autenticação": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.authentication = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tipo de Autenticação":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.authenticationType = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Senha de Autenticação":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.authenticationPassword = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Multiplas Pesquisas": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.multipleSearches = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Conteudo NSFW": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.nSFWContent = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Mostrar na Lista": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings.showNSFWInList = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Limpar o Cache": (dynamic value, SettingsOptionsController controller) {
    // OpenSettings.openAppSetting();
    SystemSettings.app();
  },
  "Restaurar": (dynamic value, SettingsOptionsController controller) {
    final SystemController systemController = SystemController();
    systemController.restartApp();
  },
};
