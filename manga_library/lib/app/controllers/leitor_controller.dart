import 'package:flutter/material.dart';
import 'package:manga_library/app/models/globais.dart';

import '../models/leitor_model.dart';

class LeitorController {
  List<ModelLeitor> capitulos = [];
  List<ModelLeitor> capitulosEmCarga = [];
  ValueNotifier<LeitorTypes> leitorTypeState =
      ValueNotifier<LeitorTypes>(LeitorTypes.ltr);

  void start(String link, String id) {
    try {
      capitulos = GlobalData.capitulosDisponiveis;

      identificarCapitulo(capitulos, id);
    } catch (e) {
      print('erro em start LeitorController');
      print(e);
    }
  }

  identificarCapitulo(List<ModelLeitor> capitulos, String id) {
    // List pages = [];
    for (int i = 0; i < capitulos.length; ++i) {
      if ((capitulos[i].id).toString() == id) {
        capitulosEmCarga.add(capitulos[i]);
      }
    }
  }

  identificarLeitor() {
    final String type = GlobalData.settings['Tipo do Leitor'];
    print('tipo do leitor: $type');
    switch (type) {
      case "vertical":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      case "ltr":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      case "rtl":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      case "webtoon":
        leitorTypeState.value = LeitorTypes.vertical;
        break;
      default:
        leitorTypeState.value = LeitorTypes.vertical;
        break;
    }
  }
}

enum LeitorTypes { vertical, ltr, rtl, webtoon }

class PagesController {
  int maxPages = 1;
  ValueNotifier<int> state = ValueNotifier<int>(0);
  // start() {
  //   state.value++;
  //   print('iniciou!');
  // }
  set setPage(int max) {
    print(max);
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
