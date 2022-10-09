import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class LibraryController {
  final OrdenateLibrary _ordenateLibrary = OrdenateLibrary();
  List<LibraryModel> librariesData = [];
  HiveController hiveController = HiveController();
  ValueNotifier<LibraryStates> state =
      ValueNotifier<LibraryStates>(LibraryStates.start);
  ValueNotifier<LibraryOrdem> ordemState =
      ValueNotifier<LibraryOrdem>(LibraryOrdem.oldToNew);
  LibraryOrdem oldOrdem = LibraryOrdem.oldToNew;
  String ordemType = "pattern";

  start() async {
    state.value = LibraryStates.loading;
    try {
      await updateTemporallyOrdem("pattern");

      state.value = LibraryStates.sucess;
    } catch (e, s) {
      debugPrint('erro no start LibraryController: $e');
      debugPrint('$s');
      state.value = LibraryStates.error;
    }
  }

  Future<void> updateTemporallyOrdem(String type) async {
    setStateOrdenacion(type);
    await setLibraryOrdem(ordemState.value);
    state.value = LibraryStates.loading;
    // set state
    state.value = LibraryStates.sucess;
  }

  void setStateOrdenacion(String type) {
    ordemType = type;
    if (type == "pattern") {
      type = GlobalData.settings['Ordenação'];
    }
    oldOrdem = ordemState.value;
    switch (type) {
      case "oldtonew":
        ordemState.value = LibraryOrdem.oldToNew;
        break;
      case "newtoold":
        ordemState.value = LibraryOrdem.newToOld;
        break;
      case "alfabetic":
        ordemState.value = LibraryOrdem.aToZ;
        break;
    }
  }

  setLibraryOrdem(LibraryOrdem ordem) async {
    librariesData.isEmpty
        ? librariesData = await hiveController.getLibraries()
        : debugPrint("não está vazio em setLibraryOrdem");

    switch (ordem) {
      case LibraryOrdem.oldToNew:
        if (oldOrdem == LibraryOrdem.newToOld) {
          librariesData = await _ordenateLibrary.reverse(librariesData);
        } else if (oldOrdem == LibraryOrdem.aToZ) {
          librariesData = await hiveController.getLibraries();
          // librariesData = await _ordenateLibrary.
        }
        break;
      case LibraryOrdem.newToOld:
        if (oldOrdem == LibraryOrdem.oldToNew) {
          librariesData = await _ordenateLibrary.reverse(librariesData);
        } else if (oldOrdem == LibraryOrdem.aToZ) {
          librariesData = await hiveController.getLibraries();
        }
        break;
      case LibraryOrdem.aToZ:
        librariesData = await _ordenateLibrary.toAZ(librariesData);
        break;
    }
  }
}

enum LibraryStates { start, loading, sucess, error }

enum LibraryOrdem { oldToNew, newToOld, aToZ } // aToZ == A-Z

class OrdenateLibrary {
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
