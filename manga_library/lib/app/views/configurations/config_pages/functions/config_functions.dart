import 'package:flutter/rendering.dart';
import 'package:manga_library/app/views/configurations/config_pages/controller/page_config_controller.dart';

import '../../../../controllers/system_config.dart';
import '../../../../models/globais.dart';

var settings = GlobalData.settings;

Map<String, Function> settingsFunctions = {
  "Ordenação": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Ordenação: $value");
    GlobalData.settings['Ordenação'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tamanho dos quadros": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor de Tamanho dos quadros: $value");
    GlobalData.settings['Tamanho dos quadros'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Atualizar":
      (dynamic value, SettingsOptionsController controller) {
        debugPrint("alterar o valor de Atualizar: $value");
        GlobalData.settings['Atualizar'] = value;
        final ConfigSystemController configSystemController =
            ConfigSystemController();
        configSystemController.update(settings);
        controller.updateSetting();
      },
  "Atualizar as Capas":
      (dynamic value, SettingsOptionsController controller) {
        debugPrint("alterar o valor de Tamanho dos quadros: $value");
        GlobalData.settings['Atualizar as Capas'] = value;
        final ConfigSystemController configSystemController =
            ConfigSystemController();
        configSystemController.update(settings);
        controller.updateSetting();
      },
  "Tema": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Tema'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Cor da Interface": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Cor da Interface'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Idioma": (dynamic value, SettingsOptionsController controller) {},
  "Rolar a Barra": (dynamic value, SettingsOptionsController controller) {
    GlobalData.settings['Rolar a Barra'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tipo do Leitor": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Tipo do Leitor'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Cor de fundo": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor Cor de fundo = $value");
    GlobalData.settings['Cor de fundo'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Orientação do Leitor":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Orientação do Leitor'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Qualidade": (dynamic value, SettingsOptionsController controller) {
    GlobalData.settings['Qualidade'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tela cheia": (dynamic value, SettingsOptionsController controller) {
    debugPrint("valor de Tela cheia: $value");
    GlobalData.settings['Tela cheia'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Local de armazenamento":
      (dynamic value, SettingsOptionsController controller) {},
  "Autenticação": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Autenticação'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tipo de Autenticação":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Tipo de Autenticação'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Senha de Autenticação":
      (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Senha de Autenticação'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Multiplas Pesquisas":
      (dynamic value, SettingsOptionsController controller) {},
  "Conteudo NSFW": (dynamic value, SettingsOptionsController controller) {},
  "Mostrar na Lista": (dynamic value, SettingsOptionsController controller) {},
  "Limpar o Cache": (dynamic value, SettingsOptionsController controller) {},
  "Restaurar": (dynamic value, SettingsOptionsController controller) {
    final SystemController systemController = SystemController();
    systemController.restartApp();
  },
};
