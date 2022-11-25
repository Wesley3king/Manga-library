import 'package:flutter/material.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/search_model.dart';

import '../../../../models/libraries_model.dart';

class SearchShowResultsPageController {
  final ValueNotifier<SearchShowResultsStates> state =
      ValueNotifier(SearchShowResultsStates.start);
  String lastSearch = '';
  SearchModel model = SearchModel(
      font: '', books: [], idExtension: 0, state: SearchStates.error);
  void start(String txt) async {
    state.value = SearchShowResultsStates.loading;
    try {
      final SearchModel? data = GlobalData.searchModelSelected;
      if (data != null) {
        model = data;
        lastSearch = txt;
      }
      state.value = SearchShowResultsStates.sucess;
    } catch (e) {
      debugPrint("erro no start at SearchShowResultsPageController: $e");
      state.value = SearchShowResultsStates.error;
    }
  }

  void search(String txt, int idExtension) async {
    if (!(lastSearch == txt)) {
      state.value = SearchShowResultsStates.loading;
      try {
        List<Books> data = await mapOfExtensions[idExtension]!.search(txt);
        model = SearchModel(
            font: '',
            books: data,
            idExtension: idExtension,
            state: SearchStates.sucess);
        lastSearch = txt;
        state.value = SearchShowResultsStates.sucess;
      } catch (e) {
        debugPrint("erro no search at SearchShowResultsPageController: $e");
        state.value = SearchShowResultsStates.error;
      }
    }
  }
}

enum SearchShowResultsStates { start, loading, sucess, error }
