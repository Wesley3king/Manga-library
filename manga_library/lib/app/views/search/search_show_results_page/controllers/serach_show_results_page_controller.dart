import 'package:flutter/material.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/search_model.dart';

import '../../../../models/libraries_model.dart';

class SearchShowResultsPageController {
  final ValueNotifier<SearchShowResultsStates> state =
      ValueNotifier(SearchShowResultsStates.start);
  SearchModel model = SearchModel(
      font: '', books: [], idExtension: 0, state: SearchStates.error);
  void start() async {
    state.value = SearchShowResultsStates.loading;
    try {
      final SearchModel? data = GlobalData.searchModelSelected;
      if (data != null) {
        model = data;
      }
      state.value = SearchShowResultsStates.sucess;
    } catch (e) {
      debugPrint("erro no start at SearchShowResultsPageController: $e");
      state.value = SearchShowResultsStates.error;
    }
  }

  void search(String txt, int idExtension) async {
    state.value = SearchShowResultsStates.loading;
    try {
      List<Books> data = await mapOfExtensions[idExtension]!.search(txt);
      model = SearchModel(
          font: '',
          books: data,
          idExtension: idExtension,
          state: SearchStates.sucess
        );
      state.value = SearchShowResultsStates.sucess;
    } catch (e) {
      debugPrint("erro no search at SearchShowResultsPageController: $e");
      state.value = SearchShowResultsStates.error;
    }
  }
}

enum SearchShowResultsStates { start, loading, sucess, error }
