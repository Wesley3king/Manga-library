import 'package:flutter/material.dart';
import 'package:manga_library/app/models/globais.dart';

import '../models/leitor_model.dart';

class LeitorController {
  List<ModelLeitor> capitulos = [];
  ValueNotifier<int> state = ValueNotifier<int>(0);

  void start(String link, String id) {
    try {
      capitulos = MomentData.capitulosDisponiveis;

      loadImages(capitulos, id);
    } catch (e) {
      print('erro em start LeitorController');
      print(e);
    }
  }

  loadImages(List<ModelLeitor> capitulos, String id) {
    List pages = [];
    for (int i = 0; i < capitulos.length; ++i) {
      if ((capitulos[i].id).toString() == id) {
        pages = capitulos[i].pages;
      }
    }
  }

  startNextPage() {
    //state.value = state.value + 1;
    state.value++;
  }
}
