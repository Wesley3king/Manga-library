import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';

import '../../../../../models/globais.dart';

class OcultLibraryController {
  final OrdenateOcultLibrary _ordenateLibrary = OrdenateOcultLibrary();
  List<LibraryModel> ocultLibrariesData = [];
  HiveController hiveController = HiveController();
  ValueNotifier<OcultLibraryStates> state =
      ValueNotifier<OcultLibraryStates>(OcultLibraryStates.start);
  ValueNotifier<OcultLibraryOrdem> ordemState =
      ValueNotifier<OcultLibraryOrdem>(OcultLibraryOrdem.oldToNew);
  OcultLibraryOrdem oldOrdem = OcultLibraryOrdem.oldToNew;
  String ordemType = "pattern";

  start() async {
    state.value = OcultLibraryStates.loading;
    try {
      // ocultLibrariesData = await hiveController.getOcultLibraries();
       await updateTemporallyOrdem("pattern");
      state.value = OcultLibraryStates.sucess;

    } catch (e, s) {
      debugPrint('erro no start LibraryOcultController: $e');
      debugPrint('$s');
      state.value = OcultLibraryStates.error;
    }
  }
  Future<void> updateTemporallyOrdem(String type) async {
    debugPrint("passou 1 !");
    setStateOrdenacion(type);
    debugPrint("passou 2 !");
    await setLibraryOrdem(ordemState.value);
    state.value = OcultLibraryStates.loading;
    debugPrint("CHEGOU AQUI!");
    // set state
    state.value = OcultLibraryStates.sucess;
    debugPrint("Finalizou");
  }

  void setStateOrdenacion(String type) {
    ordemType = type;
    if (type == "pattern") {
      type = GlobalData.settings['Ordenação'];
    }
    oldOrdem = ordemState.value;
    switch (type) {
      case "oldtonew":
        ordemState.value = OcultLibraryOrdem.oldToNew;
        break;
      case "newtoold":
        ordemState.value = OcultLibraryOrdem.newToOld;
        break;
      case "alfabetic":
        ordemState.value = OcultLibraryOrdem.aToZ;
        break;
    }
  }

  setLibraryOrdem(OcultLibraryOrdem ordem) async {
    ocultLibrariesData.isEmpty
        ? ocultLibrariesData = await hiveController.getOcultLibraries()
        : debugPrint("não está vazio em setLibraryOrdem");

    switch (ordem) {
      case OcultLibraryOrdem.oldToNew:
        if (oldOrdem == OcultLibraryOrdem.newToOld) {
          ocultLibrariesData = await _ordenateLibrary.reverse(ocultLibrariesData);
        } else if (oldOrdem == OcultLibraryOrdem.aToZ) {
          ocultLibrariesData = await hiveController.getOcultLibraries();
          // librariesData = await _ordenateLibrary.
        }
        break;
      case OcultLibraryOrdem.newToOld:
        if (oldOrdem == OcultLibraryOrdem.oldToNew) {
          ocultLibrariesData = await _ordenateLibrary.reverse(ocultLibrariesData);
        } else if (oldOrdem == OcultLibraryOrdem.aToZ) {
          ocultLibrariesData = await hiveController.getOcultLibraries();
        }
        break;
      case OcultLibraryOrdem.aToZ:
        ocultLibrariesData = await _ordenateLibrary.toAZ(ocultLibrariesData);
        break;
    }
  }
}

enum OcultLibraryStates { start, loading, sucess, error }

enum OcultLibraryOrdem { oldToNew, newToOld, aToZ } // aToZ == A-Z

class OrdenateOcultLibrary {
  final String letters = "0123456789abcdefghijklmnopqrstuvwxyz";
  Future<List<LibraryModel>> reverse(List<LibraryModel> models) async {
    for (int i = 0; i < models.length; ++i) {
      models[i].books = models[i].books.reversed.toList();
    }
    return models;
  }

  Future<List<LibraryModel>> toAZ(List<LibraryModel> models) async {
    // MODELS
    for (int i = 0; i < models.length; ++i) {
      List<Books> allBooks = models[i].books;
      List<Books> books = [];
      List<Map<String, dynamic>> removeLinks = [];
      // LETTERS
      for (int letterIndex = 0; letterIndex < letters.length; ++letterIndex) {
        String letter = letters[letterIndex];
        // bool added = false;
        // BOOKS
        for (int bookIndex = 0; bookIndex < allBooks.length; ++bookIndex) {
          // debugPrint("teste: ${allBooks[bookIndex].name.startsWith(letter)}");
          RegExp regex = RegExp(letter, caseSensitive: false);
          if (allBooks[bookIndex].name.startsWith(regex, 0)) {
            books.add(allBooks[bookIndex]);
            removeLinks.add({
              "link": allBooks[bookIndex].link,
              "idExtension": allBooks[bookIndex].idExtension
            });
            // break;
          }
        }
        // remove estes livros, depois limpa a lista de remoção
        for (Map<String, dynamic> map in removeLinks) {
          allBooks.removeWhere((book) => (book.link == map['link']) && (book.idExtension == map['idExtension']));
        }
        removeLinks.clear();
      }
      books.addAll(allBooks);
      models[i].books = books;
    }
    return models;
  }
}