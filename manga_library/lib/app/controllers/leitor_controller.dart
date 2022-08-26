import 'package:flutter/material.dart';
import 'package:manga_library/app/models/globais.dart';

import '../models/leitor_model.dart';

class LeitorController {
  List<ModelLeitor> capitulos = [];
  List<ModelLeitor> capitulosEmCarga = [];

  void start(String link, String id) {
    try {
      capitulos = MomentData.capitulosDisponiveis;

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
}

class PagesController {
  int maxPages = 0;
  ValueNotifier<int> state = ValueNotifier<int>(1);
  // start() {
  //   state.value++;
  //   print('iniciou!');
  // }
  set setMaxPages(int max) {
    maxPages = max;
  }

  startNextPage() {
    if (state.value < maxPages) {
      state.value++;
    }
    print('state = ${state.value}');
    print('max = $maxPages');

  }
}
