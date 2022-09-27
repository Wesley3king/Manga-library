import 'package:flutter/material.dart';
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

  void start(String link, String id, int idExtension) async {
    state.value = LeitorStates.loading;
    try {
      capitulos = GlobalData.capitulosDisponiveis;
      print(
          "--------------------------- \n id leitor: $id - length: ${capitulos.length}\n idExtension: $idExtension  \n------------------------");
      // _identificarCapitulo(capitulos, id);

      // buscar pelas paginas
      debugPrint("======= capitulos ==========");
      Capitulos cap =
          await mapOfExtensions[idExtension].getPages(id, capitulos);
      // debugPrint("$cap");
      capitulosEmCarga.add(cap);
      debugPrint("=========== em carga =============");
      print(capitulosEmCarga);

      setFilterQuality();
      setReaderType();
      state.value = LeitorStates.sucess;
    } catch (e) {
      print('erro em start LeitorController');
      print(e);
      state.value = LeitorStates.error;
    }
  }

  // void _identificarCapitulo(List<Capitulos> capitulos, String id) {
  //   // List pages = [];
  //   bool adicionated = false;
  //   try {
  //     for (int i = 0; i < capitulos.length; ++i) {
  //       //print("teste: num cap: ${capitulos[i].id} $id, id: $id / ${int.parse(capitulos[i].id) == int.parse(id)}");
  //       if (int.parse(capitulos[i].id) == int.parse(id)) {
  //         capitulosEmCarga.add(capitulos[i]);
  //         adicionated = true;
  //         break;
  //       }
  //     }
  //   } catch (e) {
  //     print("não é de numero");
  //     RegExp regex = RegExp(id, caseSensitive: false);
  //     for (int i = 0; i < capitulos.length; ++i) {
  //       print(
  //           "teste: cap: ${capitulos[i].capitulo} ${capitulos[i].id}, id: $id / ${capitulos[i].id.toString().contains(regex)}");
  //       if (capitulos[i].id.toString().contains(regex)) {
  //         print("achei o capitulo!");
  //         capitulosEmCarga.add(capitulos[i]);
  //         adicionated = true;
  //         break;
  //       }
  //     }
  //   }
  //   if (!adicionated) {
  //     print("não achei o capitulo");
  //     capitulosEmCarga.add(Capitulos(
  //         capitulo: "",
  //         id: 0,
  //         pages: [],
  //         disponivel: false,
  //         download: false,
  //         readed: false,
  //         downloadPages: []));
  //   }
  // }

  // void _identificarLeitor() {
  //   final String type = GlobalData.settings['Tipo do Leitor'];
  //   print('tipo do leitor: $type');
  //   switch (type) {
  //     case "vertical":
  //       leitorTypeState.value = LeitorTypes.vertical;
  //       break;
  //     case "ltr":
  //       leitorTypeState.value = LeitorTypes.ltr;
  //       break;
  //     case "rtl":
  //       leitorTypeState.value = LeitorTypes.rtl;
  //       break;
  //     case "ltrlist":
  //       leitorTypeState.value = LeitorTypes.ltrlist;
  //       break;
  //     case "rtllist":
  //       leitorTypeState.value = LeitorTypes.rtllist;
  //       break;
  //     case "webtoon":
  //       leitorTypeState.value = LeitorTypes.webtoon;
  //       break;
  //     default:
  //       print("default do leitor acionado!");
  //       leitorTypeState.value = LeitorTypes.vertical;
  //       break;
  //   }
  // }

  void setReaderType([String? type]) {
    type ??= GlobalData.settings['Tipo do Leitor'];
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
}

enum LeitorStates { start, loading, sucess, error }

enum LeitorTypes { vertical, ltr, rtl, ltrlist, rtllist, webtoon }

enum LeitorFilterQuality { none, low, medium, hight }

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
