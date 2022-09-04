import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/search_model.dart';

class SearchController {
  List<SearchModel> result = [];
  static bool finalized = false;
  String lastSearch = "";
  List<dynamic> extensions = [ExtensionMangaYabu()];

  ValueNotifier<SearchStates> state = ValueNotifier(SearchStates.start);
  void start() {
    try {
      state.value = SearchStates.loading;
      state.value = SearchStates.sucess;
    } catch (e) {
      print(e);
      state.value = SearchStates.error;
    }
  }

  Future<void> search(String txt) async {
    try {
      finalized = false;
      print("$lastSearch / $txt");
      if (lastSearch != txt) {
        result = [];
        for (int i = 0; i < extensions.length; ++i) {
          state.value = SearchStates.loading;
          print('iniciado');
          result.add(await extensions[i].search(txt));
          print('terminado!');
          print(result[0].books);
          state.value = SearchStates.sucess;
        }
      }
      state.value = SearchStates.sucess;
      finalized = true;
      lastSearch = txt;
    } catch (e) {
      print("erro no search: $e");
      state.value = SearchStates.error;
    }
  }
}

enum SearchStates { start, loading, sucess, error }
