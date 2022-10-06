import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class OcultLibraryController {
  List<LibraryModel> ocultLibrariesData = [];
  HiveController hiveController = HiveController();
  ValueNotifier<OcultLibraryStates> state =
      ValueNotifier<OcultLibraryStates>(OcultLibraryStates.start);

  start() async {
    state.value = OcultLibraryStates.loading;
    try {
      ocultLibrariesData = await hiveController.getOcultLibraries();
      state.value = OcultLibraryStates.sucess;

    } catch (e, s) {
      debugPrint('erro no start LibraryOcultController: $e');
      debugPrint('$s');
      state.value = OcultLibraryStates.error;
    }
  }
}

enum OcultLibraryStates { start, loading, sucess, error }
