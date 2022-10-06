import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../../../../../../models/libraries_model.dart';

class LibraryConfigController {
  final HiveController _hiveController = HiveController();
  ValueNotifier<OcultLibraryConfigStates> state =
      ValueNotifier<OcultLibraryConfigStates>(OcultLibraryConfigStates.start);
  List<LibraryModel> libraries = [];
  void start() async {
    state.value = OcultLibraryConfigStates.loading;
    try {
      libraries = await _hiveController.getLibraries();
      state.value = OcultLibraryConfigStates.sucess;
    } catch (e) {
      debugPrint("erro no start at LibraryConfigController: $e");
      state.value = OcultLibraryConfigStates.error;
    }
  }

  void restart() async {
    state.value = OcultLibraryConfigStates.restarting;
    try {
      libraries = await _hiveController.getLibraries();
      state.value = OcultLibraryConfigStates.sucess;
    } catch (e) {
      debugPrint("erro no restart at LibraryConfigController: $e");
      state.value = OcultLibraryConfigStates.error;
    }
  }

  Future<void> addLibrary(String library) async {
    LibraryModel model = LibraryModel(library: library, books: []);
    try {
      List<LibraryModel> libraries = await _hiveController.getLibraries();
      await _hiveController.updateLibraries([...libraries, model]);
      restart();
    } catch (e) {
      print("erro no addLibrary at LibraryConfigController: $e");
    }
  }

  Future<void> removeLibrary(String library) async {
    try {
      libraries.removeWhere((LibraryModel model) => model.library == library);
      await _hiveController.updateLibraries(libraries);
      restart();
    } catch (e) {
      debugPrint("erro no removeLibrary at LibraryConfigController: $e");
    }
  }

  Future<void> renameLibrary(
      {required String oldName, required String newName}) async {
    try {
      for (var model in libraries) {
        if (model.library == oldName) {
          model.library = newName;
          await _hiveController.updateLibraries(libraries);
          break;
        }
      }
      restart();
    } catch (e) {
      debugPrint("erro no renameLibrary at LibraryConfigController: $e");
    }
  }

  Future<void> sortLibrary(List<LibraryModel> listOfModels) async {
    try {
      await _hiveController.updateLibraries(listOfModels);
    } catch (e) {
      debugPrint("erro no removeLibrary at LibraryConfigController: $e");
    }
  }
}

enum OcultLibraryConfigStates { start, loading, restarting, sucess, error }
