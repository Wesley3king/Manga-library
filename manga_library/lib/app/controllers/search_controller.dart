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
    // try {
    //   finalized = false;
    //   debugPrint("$lastSearch / $txt");
    //   if (lastSearch != txt) {
    //     result = [];
    //     for (int i = 0; i < extensions.length; ++i) {
    //       state.value = SearchStates.loading;
    //       debugPrint('iniciado');
    //       result.add(await extensions[i].search(txt));
    //       debugPrint('terminado!');
    //       debugPrint('${result[0].books}');
    //       state.value = SearchStates.sucess;
    //     }
    //   }
    //   state.value = SearchStates.sucess;
    //   finalized = true;
    //   lastSearch = txt;
    // } catch (e) {
    //   debugPrint("erro no search: $e");
    //   state.value = SearchStates.error;
    // }
    if (lastSearch != txt) {
      result = [];
      /// start the serach service
      if (GlobalData.settings.multipleSearches) {
        multipleSearchMachine(txt);
      } else {
        oneForOneSearchMachine(txt);
      }
      lastSearch = txt;
    }
  }

  Future<void> buildModels() async {
    for (Extension extend in extensions) {
      result.add(SearchModel(
          font: extend.nome,
          books: [],
          idExtension: extend.id,
          state: SearchStates.start));
    }
  }

  Future<void> oneForOneSearchMachine(String txt) async {
    for (int i = 0; i < result.length; ++i) {
      await processOneSearch(i, txt);
      state.value++;
    }
  }

  Future<void> multipleSearchMachine(String txt) async {}

  Future<void> processOneSearch(int index, String txt) async {
    // final SearchModel model = result[index];
    try {
      List<Books> books =
          await extensions[result[index].idExtension].search(txt);
      result[index].books = books;
      result[index].state = SearchStates.sucess;
    } catch (e) {
      debugPrint("erro no processOneSearch at SearchController: $e");
      result[index].state = SearchStates.error;
    }
  }
}
