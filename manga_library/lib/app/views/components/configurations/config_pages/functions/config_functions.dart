import 'package:flutter/rendering.dart';
import 'package:manga_library/app/views/components/configurations/config_pages/controller/page_config_controller.dart';

import '../../../../../controllers/system_config.dart';
import '../../../../../models/globais.dart';

var settings = GlobalData.settings;

Map<String, Function> settingsFunctions = {
  "Ordenação": (dynamic value, SettingsOptionsController controller) {},
  "Tamanho dos quadros":
      (dynamic value, SettingsOptionsController controller) {},
  "Atualizar as Capas":
      (dynamic value, SettingsOptionsController controller) {},
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
  "Rolar a Barra": (dynamic value, SettingsOptionsController controller) {},
  "Tipo do Leitor": (dynamic value, SettingsOptionsController controller) {
    debugPrint("alterar o valor = $value");
    GlobalData.settings['Tipo do Leitor'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Cor de fundo": (dynamic value, SettingsOptionsController controller) {},
  "Qualidade": (dynamic value, SettingsOptionsController controller) {
    GlobalData.settings['Qualidade'] = value;
    final ConfigSystemController configSystemController =
        ConfigSystemController();
    configSystemController.update(settings);
    controller.updateSetting();
  },
  "Tela cheia": (dynamic value, SettingsOptionsController controller) {},
  "Local de armazenamento":
      (dynamic value, SettingsOptionsController controller) {},
  "Autenticação": (dynamic value, SettingsOptionsController controller) {},
  "Tipo de Autenticação":
      (dynamic value, SettingsOptionsController controller) {},
  "Senha de Autenticação":
      (dynamic value, SettingsOptionsController controller) {},
  "Multiplas Pesquisas":
      (dynamic value, SettingsOptionsController controller) {},
  "Conteudo NSFW": (dynamic value, SettingsOptionsController controller) {},
  "Mostrar na Lista": (dynamic value, SettingsOptionsController controller) {},
  "Limpar o Cache": (dynamic value, SettingsOptionsController controller) {},
  "Restaurar": (dynamic value, SettingsOptionsController controller) {},
};
