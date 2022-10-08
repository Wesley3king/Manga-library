import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';

import '../models/leitor_pages.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import '../models/manga_info_offline_model.dart';

class LeitorController {
  List<Capitulos> capitulos = [];
  List<Capitulos> capitulosEmCarga = [];
  // ===== State =====
  ValueNotifier<LeitorStates> state =
      ValueNotifier<LeitorStates>(LeitorStates.start);
  // ===== Reader Type =====
  ValueNotifier<LeitorTypes> leitorTypeState =
      ValueNotifier<LeitorTypes>(LeitorTypes.ltr);
  // ===== Filter Quality =====
  ValueNotifier<LeitorFilterQuality> filterQualityState =
      ValueNotifier<LeitorFilterQuality>(LeitorFilterQuality.none);
  // ===== Orientacion =====
  // ValueNotifier<LeitorOrientacion> orientacionState =
  //     ValueNotifier<LeitorOrientacion>(LeitorOrientacion.auto);

  void start(String link, String id, int idExtension) async {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.capitulosDisponiveis;
      debugPrint(
          "--------------------------- \n id leitor: $id - length: ${capitulos.length}\n idExtension: $idExtension  \n------------------------");
      // _identificarCapitulo(capitulos, id);

      // buscar pelas paginas
      debugPrint("======= capitulos ==========");
      Capitulos cap =
          await mapOfExtensions[idExtension]!.getPages(id, capitulos);
      // debugPrint("$cap");
      capitulosEmCarga.add(cap);
      debugPrint("=========== em carga =============");
      debugPrint('$capitulosEmCarga');

      setFilterQuality();
      setOrientacion();
      setReaderType();
      state.value = LeitorStates.sucess;
    } catch (e) {
      debugPrint('erro em start LeitorController');
      debugPrint('$e');
      state.value = LeitorStates.error;
    }
  }

  void setReaderType([String? type]) {
    type ??= GlobalData.settings['Tipo do Leitor'];
    if (type == "pattern") {
      type = GlobalData.settings['Tipo do Leitor'];
    }
    switch (type) {
      // case "pattern":
      //   leitorTypeState.value = LeitorTypes.pattern;
      //   break;
      case "vertical":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      case "ltr":
        leitorTypeState.value = LeitorTypes.ltr;
        break;
      case "rtl":
        leitorTypeState.value = LeitorTypes.rtl;
        break;
      case "ltrlist":
        leitorTypeState.value = LeitorTypes.ltrlist;
        break;
      case "rtllist":
        leitorTypeState.value = LeitorTypes.rtllist;
        break;
      case "webtoon":
        leitorTypeState.value = LeitorTypes.webtoon;
        break;
      case "webview":
        leitorTypeState.value = LeitorTypes.webview;
        break;
      default:
        debugPrint("default do leitor acionado!");
        leitorTypeState.value = LeitorTypes.vertical;
        break;
    }
  }

  void setFilterQuality([String? type]) {
    type ??= GlobalData.settings['Qualidade'];
    switch (type) {
      case "none":
        filterQualityState.value = LeitorFilterQuality.none;
        break;
      case "low":
        filterQualityState.value = LeitorFilterQuality.low;
        break;
      case "medium":
        filterQualityState.value = LeitorFilterQuality.medium;
        break;
      case "hight":
        filterQualityState.value = LeitorFilterQuality.hight;
        break;
    }
  }

  void setOrientacion([String? type]) {
    type ??= GlobalData.settings['Orientação do Leitor'];
    if (type == "pattern") {
      type = GlobalData.settings['Orientação do Leitor'];
      ConfigSystemController.instance.setSystemOrientacion(type ?? "auto");
    } else {
      ConfigSystemController.instance.setSystemOrientacion(type ?? "auto");
    }
    //   switch (type) {
    //     case "auto":
    //       orientacionState.value = LeitorOrientacion.auto;
    //       break;
    //     case "portraitup":
    //       orientacionState.value = LeitorOrientacion.portraitUp;
    //       break;
    //     case "portraitdown":
    //       orientacionState.value = LeitorOrientacion.portraitDown;
    //       break;
    //     case "landscapeleft":
    //       orientacionState.value = LeitorOrientacion.landscapeLeft;
    //       break;
    //     case "landscaperight":
    //       orientacionState.value = LeitorOrientacion.landscapeRight;
    //       break;
    //   }
  }
}

enum LeitorStates { start, loading, sucess, error }

enum LeitorTypes { vertical, ltr, rtl, ltrlist, rtllist, webtoon, webview }

enum LeitorFilterQuality { none, low, medium, hight }

// enum LeitorOrientacion {
//   auto,
//   portraitUp,
//   portraitDown,
//   landscapeLeft,
//   landscapeRight
// }

class PagesController {
  // int maxPages = 1;
  ValueNotifier<int> state = ValueNotifier<int>(1);
  // start() {
  //   state.value++;
  //   print('iniciou!');
  // }
  set setPage(int max) {
    debugPrint('$max');
    state.value = max;
  }

  // startNextPage() {
  //   if (state.value < maxPages) {
  //     state.value++;
  //   }
  //   print('state = ${state.value}');
  //   print('max = $maxPages');

  // }
}
