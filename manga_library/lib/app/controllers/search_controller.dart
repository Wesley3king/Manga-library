import 'package:flutter/material.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/models/globais.dart';
// import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
// import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/search_model.dart';

import '../models/libraries_model.dart';

// import 'extensions/manga_yabu/extension_yabu.dart';
// import 'extensions/manga_yabu/adimin/extension_manga_yabu_adimin.dart';

class SearchController {
  List<SearchModel> result = [];
  static bool finalized = false;
  String lastSearch = "";
  final List<dynamic> extensions = listOfExtensions;
  final ValueNotifier<int> state = ValueNotifier<int>(-1);

  /// multiple searchs mode
  int allResultsIndice = 0;
  int atualRequestsCount = 0;
  int finalizedRequestCount = 0;
  //List<dynamic> extensions = [ExtensionMangaYabu(), ExtensionMangaYabuAdimin()];

  // ValueNotifier<SearchStates> state = ValueNotifier(SearchStates.sucess);
  // void start() {
  //   try {
  //     state.value = SearchStates.loading;
  //     state.value = SearchStates.sucess;
  //   } catch (e) {
  //     print(e);
  //     state.value = SearchStates.error;
  //   }
  // }

  Future<void> search(String txt) async {
    state.value = 0;
    if (lastSearch != txt) {
      result = [];
      buildModels();

      /// start the serach service
      if (GlobalData.settings.multipleSearches) {
        multipleSearchMachine(txt);
      } else {
        oneForOneSearchMachine(txt);
      }
      lastSearch = txt;
    }
  }

  void buildModels() {
    for (Extension extend in extensions) {
      result.add(SearchModel(
          font: extend.nome,
          books: [],
          idExtension: extend.id,
          state: SearchStates.start));
    }
    // result = result.reversed.toList();
  }

  Future<void> oneForOneSearchMachine(String txt) async {
    for (int i = 0; i < result.length; ++i) {
      await processOneSearch(i, txt);
      state.value++;
    }
  }

  void multipleSearchMachine(String txt) {
    if (allResultsIndice < result.length) {
      debugPrint(
          "teste de parada: ${(result.length - allResultsIndice + 1) < 3} / ${result.length - allResultsIndice + 1}");
      final int restantes = result.length - allResultsIndice + 1;
      if (restantes < 3) {
        /// implement this
        for (int i = allResultsIndice; i < result.length; ++i) {
          processOneSearch(allResultsIndice, txt);
          allResultsIndice++;
        }
      } else {
        processOneSearch(allResultsIndice, txt);
        processOneSearch(allResultsIndice + 1, txt);
        processOneSearch(allResultsIndice + 2, txt);
        allResultsIndice += 3;
      }
    } else {
      allResultsIndice = 0;
    }
  }

  void checkIfCanContinue(String txt) {
    if (finalizedRequestCount == 2) {
      multipleSearchMachine(txt);
      finalizedRequestCount = 0;
    } else {
      finalizedRequestCount++;
    }
  }

  Future<void> processOneSearch(int index, String txt) async {
    try {
      List<Books> books =
          await mapOfExtensions[result[index].idExtension]!.search(txt);
      // debugPrint('books ==== $books / index: $index - ${result[index].idExtension} / erro : ${extensions[result[index].idExtension].nome}');
      result[index].books = books;
      result[index].state = SearchStates.sucess;
      state.value++;
      debugPrint("concluido: $index");
      checkIfCanContinue(txt);
    } catch (e) {
      debugPrint("erro no processOneSearch at SearchController: $e");
      result[index].state = SearchStates.error;
    }
  }
}
