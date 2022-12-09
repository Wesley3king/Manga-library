import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
// import 'package:manga_library/app/models/globais.dart';

Map<String, Icon> readerTypeIcons = {
  "pattern": const Icon(Icons.system_security_update_good),
  "vertical": const Icon(Icons.system_security_update_outlined),
  "ltr": const Icon(Icons.send_to_mobile),
  "rtl": const Icon(Icons.smartphone),
  "ltrlist": const Icon(Icons.install_mobile_rounded),
  "rtllist": const Icon(Icons.no_cell_outlined),
  "webtoon": const Icon(Icons.system_security_update),
  "webview": const Icon(Icons.system_security_update),
  "novel": const Icon(Icons.text_snippet_outlined)
};

Widget buildSetLeitorType(LeitorController controller) {
  final List<Map<String, String>> options = [
    {"option": "Padrão", "value": "pattern"},
    {"option": "Vertical", "value": "vertical"},
    {"option": "Esquerda para Direita", "value": "ltr"},
    {"option": "Direita para esquerda", "value": "rtl"},
    {"option": "Lista ltr", "value": "ltrlist"},
    {"option": "Lista rtl", "value": "rtllist"},
    {"option": "Webtoon", "value": "webtoon"},
    {"option": "Webview (on-line)", "value": "webview"},
    {"option": "Novel (only for novel)", "value": "novel"}
  ];

  String type = "";
  switch (controller.leitorType) {
    case LeitorTypes.vertical:
      type = "vertical";
      break;
    case LeitorTypes.ltr:
      type = "ltr";
      break;
    case LeitorTypes.rtl:
      type = "rtl";
      break;
    case LeitorTypes.ltrlist:
      type = "ltrlist";
      break;
    case LeitorTypes.rtllist:
      type = "rtllist";
      break;
    case LeitorTypes.webtoon:
      type = "webtoon";
      break;
    case LeitorTypes.webview:
      type = "webview";
      break;
    case LeitorTypes.novel:
      type = "novel";
      break;
  }

  List<PopupMenuItem<String>> popUpMenuItens = [];
  for (Map<String, String> option in options) {
    // debugPrint("typeoption: ${controller.leitorTypeUi.toString()}");
    popUpMenuItens.add(PopupMenuItem(
        enabled: controller.leitorTypeUi == option['value'] ? false : true,
        onTap: () => controller.setReaderType(option['value']!),
        child: Text(option['option']!)));
  }

  return PopupMenuButton<String>(
    icon: readerTypeIcons[type],
    initialValue: "pattern",
    tooltip: "Tipo de Leitor",
    itemBuilder: (context) => popUpMenuItens,
  );
}
// -----------------------------------------------------------------
//             ========= Filter Quality ==========
// -----------------------------------------------------------------

Map<String, Icon> filterQualityIcons = {
  "pattern": const Icon(Icons.filter_list),
  "low": const Icon(Icons.filter_alt_outlined),
  "medium": const Icon(Icons.filter_alt_rounded),
  "hight": const Icon(Icons.filter_alt_sharp),
  "none": const Icon(Icons.filter_alt_off_outlined)
};

Widget buildFilterQuality(LeitorController controller) {
  final List<Map<String, String>> options = [
    {"option": "Padrão", "value": "pattern"},
    {"option": "Baixo", "value": "low"},
    {"option": "Médio", "value": "medium"},
    {"option": "Alto", "value": "hight"},
    {"option": "Nenhum", "value": "none"},
  ];

  List<PopupMenuItem<String>> popUpMenuItens = [];
  // debugPrint("typeoption: ${controller.leitorTypeUi}");
  for (Map<String, String> option in options) {
    popUpMenuItens.add(PopupMenuItem(
        enabled: controller.filterQualityUi == option['value'] ? false : true,
        onTap: () => controller.setFilterQuality(option['value']!),
        child: Text(option['option']!)));
  }

  String type = "";
  switch (controller.filterQuality) {
    case LeitorFilterQuality.none:
      type = "none";
      break;
    case LeitorFilterQuality.low:
      type = "low";
      break;
    case LeitorFilterQuality.medium:
      type = "medium";
      break;
    case LeitorFilterQuality.hight:
      type = "hight";
      break;
  }
  return PopupMenuButton<String>(
    icon: filterQualityIcons[type],
    initialValue: "pattern",
    tooltip: "Filtro de qualidade",
    itemBuilder: (context) => popUpMenuItens,
  );
}

// -----------------------------------------------------------------
//             ========= Orientacion ==========
// -----------------------------------------------------------------

Widget buildOrientacion(LeitorController controller, Function setState) {
  final List<Map<String, String>> options = [
    {"option": "Padrão", "value": "pattern"},
    {"option": "Seguir o Sistema", "value": "auto"},
    {"option": "Retrato", "value": "portraitup"},
    {"option": "Retrato Invertido", "value": "portraitdown"},
    {"option": "Paisagem Esquerda", "value": "landscapeleft"},
    {"option": "Paisagem Direita", "value": "landscaperight"},
  ];

  List<PopupMenuItem<String>> popUpMenuItens = [];
  // debugPrint("typeoption: ${controller.leitorTypeUi}");
  for (Map<String, String> option in options) {
    popUpMenuItens.add(PopupMenuItem(
        enabled: controller.orientacionUi == option['value']! ? false : true,
        onTap: () {
          controller.setOrientacion(option['value']!);
          setState(() {});
        },
        child: Text(option['option']!)));
  }

  return PopupMenuButton<String>(
    icon: const Icon(Icons.screen_rotation),
    initialValue: "pattern",
    tooltip: "Orientação do leitor",
    itemBuilder: (context) => popUpMenuItens,
  );
}
