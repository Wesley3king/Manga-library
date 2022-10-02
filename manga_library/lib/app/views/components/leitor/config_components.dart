import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/models/globais.dart';

Map<String, Icon> readerTypeIcons = {
  "vertical": const Icon(Icons.system_security_update_outlined),
  "ltr": const Icon(Icons.send_to_mobile),
  "rtl": const Icon(Icons.smartphone),
  "ltrlist": const Icon(Icons.install_mobile_rounded),
  "rtllist": const Icon(Icons.no_cell_outlined),
  "webtoon": const Icon(Icons.system_security_update),
  "webview": const Icon(Icons.system_security_update),
};

Widget buildSetLeitorType(LeitorController controller) {
  final List<Map<String, String>> options = [
    {"option": "Vertical", "value": "vertical"},
    {"option": "Esquerda para Direita", "value": "ltr"},
    {"option": "Direita para esquerda", "value": "rtl"},
    {"option": "Lista ltr", "value": "ltrlist"},
    {"option": "Lista rtl", "value": "rtllist"},
    {"option": "Webtoon", "value": "webtoon"},
    {"option": "Webview (on-line)", "value": "webview"}
  ];

  List<PopupMenuItem<String>> popUpMenuItens = [];
  for (Map<String, String> option in options) {
    popUpMenuItens.add(PopupMenuItem(
        child: Text(option['option']!),
        onTap: () => controller.setReaderType(option['value']!)));
  }
  String type = "";
  switch (controller.leitorTypeState.value) {
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
  }
  return PopupMenuButton<String>(
    icon: readerTypeIcons[type],
    itemBuilder: (context) => popUpMenuItens,
  );
}
// -----------------------------------------------------------------
//             ========= Filter Quality ==========
// -----------------------------------------------------------------

Map<String, Icon> filterQualityIcons = {
  "low": const Icon(Icons.filter_alt_outlined),
  "medium": const Icon(Icons.filter_alt_rounded),
  "hight": const Icon(Icons.filter_alt_sharp),
  "none": const Icon(Icons.filter_alt_off_outlined)
};

Widget buildFilterQuality(LeitorController controller) {
  final List<Map<String, String>> options = [
    {"option": "Baixo", "value": "low"},
    {"option": "Médio", "value": "medium"},
    {"option": "Alto", "value": "hight"},
    {"option": "Nenhum", "value": "none"},
  ];

  List<PopupMenuItem<String>> popUpMenuItens = [];
  for (Map<String, String> option in options) {
    popUpMenuItens.add(PopupMenuItem(
        child: Text(option['option']!),
        onTap: () => controller.setFilterQuality(option['value']!)));
  }

  String type = "";
  switch (controller.filterQualityState.value) {
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
    itemBuilder: (context) => popUpMenuItens,
  );
}
