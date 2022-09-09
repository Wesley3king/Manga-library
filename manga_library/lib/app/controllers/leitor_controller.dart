import 'package:flutter/material.dart';
import 'package:manga_library/app/models/globais.dart';

import '../models/leitor_model.dart';

class LeitorController {
  List<ModelLeitor> capitulos = [];
  List<ModelLeitor> capitulosEmCarga = [];
  ValueNotifier<LeitorStates> state = ValueNotifier<LeitorStates>(LeitorStates.start);
  ValueNotifier<LeitorTypes> leitorTypeState = ValueNotifier<LeitorTypes>(LeitorTypes.ltr);

  void start(String link, String id) {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.capitulosDisponiveis;

      _identificarCapitulo(capitulos, id);
      _identificarLeitor();
      state.value = LeitorStates.sucess;
    } catch (e) {
      print('erro em start LeitorController');
      print(e);
      state.value = LeitorStates.error;
    }
  }

  void _identificarCapitulo(List<ModelLeitor> capitulos, String id) {
    // List pages = [];
    for (int i = 0; i < capitulos.length; ++i) {
      if ((capitulos[i].id).toString() == id) {
        capitulosEmCarga.add(capitulos[i]);
      }
    }
  }

  void _identificarLeitor() {
    final String type = GlobalData.settings['Tipo do Leitor'];
    print('tipo do leitor: $type');
    switch (type) {
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
      default:
        print("default do leitor acionado!");
        leitorTypeState.value = LeitorTypes.vertical;
        break;
    }
  }
}

enum LeitorStates { start, loading, sucess, error }

enum LeitorTypes { vertical, ltr, rtl, ltrlist, rtllist, webtoon }

class PagesController {
  // int maxPages = 1;
  ValueNotifier<int> state = ValueNotifier<int>(1);
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
