import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class LibraryController {
  List<LibraryModel> librariesData = [];
  HiveController hiveController = HiveController();
  ValueNotifier<LibraryStates> state =
      ValueNotifier<LibraryStates>(LibraryStates.start);
  ValueNotifier<LibraryOrdem> ordemState =
      ValueNotifier<LibraryOrdem>(LibraryOrdem.oldToNew);
  LibraryOrdem oldOrdem = LibraryOrdem.oldToNew;

  start() async {
    state.value = LibraryStates.loading;
    try {
      librariesData = await hiveController.getLibraries();

      state.value = LibraryStates.sucess;
    } catch (e, s) {
      debugPrint('erro no start LibraryController: $e');
      debugPrint('$s');
      state.value = LibraryStates.error;
    }
  }

  setLibraryOrdem(LibraryOrdem ordem) {
    switch (ordem) {
      case LibraryOrdem.oldToNew:
        if (oldOrdem == LibraryOrdem.newToOld) {}
        if (oldOrdem == LibraryOrdem.aToZ) {}
        break;
      case LibraryOrdem.newToOld:
        break;
      case LibraryOrdem.aToZ:
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
      List<int> removeIndexes = [];
      // LETTERS
      for (int letterIndex = 0; letterIndex < letters.length; ++letterIndex) {
        String letter = letters[letterIndex];
        // bool added = false;
        // BOOKS
        for (int bookIndex = 0; bookIndex < allBooks.length; ++bookIndex) {
          if (allBooks[bookIndex].name.startsWith(letter)) {
            books.add(allBooks[bookIndex]);
            removeIndexes.add(bookIndex);
            break;
          }
        }
        // remove estes livros, depois limpa a lista de remoção
        for (int index in removeIndexes) {
          allBooks.removeAt(index);
        }
        removeIndexes = [];
      }
      books.addAll(allBooks);
      models[i].books = books;
    }
    return models;
  }

  Future<List<LibraryModel>> getOldToNew() async {
    HiveController hiveController = HiveController();
    return await hiveController.getLibraries();
  }
}
