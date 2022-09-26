import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
// import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
// import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/search_model.dart';

// import 'extensions/manga_yabu/extension_yabu.dart';
// import 'extensions/manga_yabu/adimin/extension_manga_yabu_adimin.dart';

class SearchController {
  List<SearchModel> result = [];
  static bool finalized = false;
  String lastSearch = "";
  final List<dynamic> extensions = listOfExtensions;
  //List<dynamic> extensions = [ExtensionMangaYabu(), ExtensionMangaYabuAdimin()];

  ValueNotifier<SearchStates> state = ValueNotifier(SearchStates.sucess);
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
    try {
      finalized = false;
      debugPrint("$lastSearch / $txt");
      if (lastSearch != txt) {
        result = [];
        for (int i = 0; i < extensions.length; ++i) {
          state.value = SearchStates.loading;
          debugPrint('iniciado');
          result.add(await extensions[i].search(txt));
          debugPrint('terminado!');
          debugPrint('${result[0].books}');
          state.value = SearchStates.sucess;
        }
      }
      state.value = SearchStates.sucess;
      finalized = true;
      lastSearch = txt;
    } catch (e) {
      debugPrint("erro no search: $e");
      state.value = SearchStates.error;
    }
  }
}

enum SearchStates { start, loading, sucess, error }
