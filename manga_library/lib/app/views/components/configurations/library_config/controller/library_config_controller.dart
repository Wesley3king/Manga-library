import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../../../../../models/libraries_model.dart';

class LibraryConfigController {
  final HiveController _hiveController = HiveController();
  ValueNotifier<LibraryConfigStates> state =
      ValueNotifier<LibraryConfigStates>(LibraryConfigStates.start);
  List<LibraryModel> libraries = [];
  start() async {
    state.value = LibraryConfigStates.loading;
    try {
      libraries = await _hiveController.getLibraries();
      state.value = LibraryConfigStates.sucess;
    } catch (e) {
      print("erro no start at LibraryConfigController: $e");
      state.value = LibraryConfigStates.error;
    }
  }

  Future addLibrary(String library) async {
    LibraryModel model = LibraryModel(library: library, books: []);
    try {
      List<LibraryModel> libraries = await _hiveController.getLibraries();
      await _hiveController.updateLibraries([...libraries, model]);
    } catch (e) {
      print("erro no addLibrary at LibraryConfigController: $e");
    }
  }

  Future removeLibrary(String library) async {
    try {
      libraries.removeWhere((LibraryModel model) => model.library == library);
      await _hiveController.updateLibraries(libraries);
    } catch (e) {
      print("erro no removeLibrary at LibraryConfigController: $e");
    }
  }
}

enum LibraryConfigStates { start, loading, sucess, error }
