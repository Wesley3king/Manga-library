import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class LibraryController {
  List<LibraryModel> librariesData = [];
  HiveController hiveController = HiveController();
  ValueNotifier<LibraryStates> state =
      ValueNotifier<LibraryStates>(LibraryStates.start);

  start() async {
    state.value = LibraryStates.loading;
    try {
      librariesData = await hiveController.getLibraries();
      state.value = LibraryStates.sucess;

    } catch (e, s) {
      print('erro no start LibraryController');
      print(e);
      print(s);
      state.value = LibraryStates.error;
    }
  }
}

enum LibraryStates { start, loading, sucess, error }
