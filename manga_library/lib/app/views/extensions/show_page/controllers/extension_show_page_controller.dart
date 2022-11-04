import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/home_page_model.dart';

class ExtensionShowPageController {
  ValueNotifier<ShowPageStates> state =
      ValueNotifier<ShowPageStates>(ShowPageStates.start);
  List<ModelHomeBook> data = [];

  void start(int idExtension) async {
    state.value = ShowPageStates.loading;
    try {
      List<ModelHomePage> dados =
          await mapOfExtensions[idExtension]!.homePage();
      for (ModelHomePage model in dados) {
        data.addAll(model.books);
      }
      state.value = ShowPageStates.sucess;
    } catch (e) {
      debugPrint("erro no start at : $e");
      state.value = ShowPageStates.error;
    }
  }
}

enum ShowPageStates { start, loading, sucess, error }
