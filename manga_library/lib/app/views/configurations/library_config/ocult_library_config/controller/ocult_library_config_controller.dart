import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';


class OcultLibraryConfigController {
  final HiveController _hiveController = HiveController();
  ValueNotifier<LibraryConfigStates> state =
      ValueNotifier<LibraryConfigStates>(LibraryConfigStates.start);
  List<LibraryModel> ocultlibraries = [];
  void start() async {
    state.value = LibraryConfigStates.loading;
    try {
      ocultlibraries = await _hiveController.getOcultLibraries();
      state.value = LibraryConfigStates.sucess;
    } catch (e) {
      debugPrint("erro no start at LibraryConfigController: $e");
      state.value = LibraryConfigStates.error;
    }
  }

  void restart() async {
    state.value = LibraryConfigStates.restarting;
    try {
      ocultlibraries = await _hiveController.getOcultLibraries();
      state.value = LibraryConfigStates.sucess;
    } catch (e) {
      debugPrint("erro no restart at LibraryConfigController: $e");
      state.value = LibraryConfigStates.error;
    }
  }

  Future<void> addLibrary(String library) async {
    LibraryModel model = LibraryModel(library: library, books: []);
    try {
      List<LibraryModel> libraries = await _hiveController.getOcultLibraries();
      await _hiveController.updateOcultLibraries([...libraries, model]);
      restart();
    } catch (e) {
      debugPrint("erro no addLibrary at LibraryConfigController: $e");
    }
  }

  Future<void> removeLibrary(String library) async {
    try {
      ocultlibraries.removeWhere((LibraryModel model) => model.library == library);
      await _hiveController.updateOcultLibraries(ocultlibraries);
      restart();
    } catch (e) {
      debugPrint("erro no removeLibrary at LibraryConfigController: $e");
    }
  }

  Future<void> renameLibrary(
      {required String oldName, required String newName}) async {
    try {
      for (var model in ocultlibraries) {
        if (model.library == oldName) {
          model.library = newName;
          await _hiveController.updateOcultLibraries(ocultlibraries);
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
      await _hiveController.updateOcultLibraries(listOfModels);
    } catch (e) {
      debugPrint("erro no removeLibrary at LibraryConfigController: $e");
    }
  }
}

enum LibraryConfigStates { start, loading, restarting, sucess, error }
