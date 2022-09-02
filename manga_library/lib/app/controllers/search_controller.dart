import 'package:flutter/material.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class SearchController {
  List<Map<String, dynamic>> result = [];
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

  search(String txt) async {}
}

enum SearchStates { start, loading, sucess, error }
