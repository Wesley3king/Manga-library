import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../../models/client_data_model.dart';

class LibraryController {
  final OrdenateLibrary _ordenateLibrary = OrdenateLibrary();

  /// ============= DATA =============
  List<LibraryModel> librariesData = [];

  /// === DATABASE CONTROLLER ===========
  HiveController hiveController = HiveController();

  /// ========== STATE ===========
  ValueNotifier<LibraryStates> state =
      ValueNotifier<LibraryStates>(LibraryStates.start);

  /// =============== ORDENATION STATE ===============
  ValueNotifier<LibraryOrdem> ordemState =
      ValueNotifier<LibraryOrdem>(LibraryOrdem.oldToNew);

  /// =========== ORDENATION DATA ============
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
      type = GlobalData.settings.ordination;
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
        ? librariesData = await getProcessedDataForLibrary()
        : debugPrint("não está vazio em setLibraryOrdem");

    switch (ordem) {
      case LibraryOrdem.oldToNew:
        if (oldOrdem == LibraryOrdem.newToOld) {
          librariesData = await _ordenateLibrary.reverse(librariesData);
        } else if (oldOrdem == LibraryOrdem.aToZ) {
          librariesData = await getProcessedDataForLibrary();
          // librariesData = await _ordenateLibrary.
        }
        break;
      case LibraryOrdem.newToOld:
        if (oldOrdem == LibraryOrdem.oldToNew) {
          librariesData = await _ordenateLibrary.reverse(librariesData);
        } else if (oldOrdem == LibraryOrdem.aToZ) {
          librariesData = await getProcessedDataForLibrary();
        }
        break;
      case LibraryOrdem.aToZ:
        librariesData = await _ordenateLibrary.toAZ(librariesData);
        break;
    }
  }

  Future<List<LibraryModel>> getProcessedDataForLibrary() async {
    final List<LibraryModel> models = await hiveController.getLibraries();
    return await ProcessDataFromLibrary().processLibraryData(models) ?? [];
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
          allBooks.removeWhere((book) =>
              (book.link == map['link']) &&
              (book.idExtension == map['idExtension']));
        }
        removeLinks.clear();
      }
      books.addAll(allBooks);
      models[i].books = books;
    }
    return models;
  }
}

class ProcessDataFromLibrary {
  final MangaInfoOffLineController _controller = MangaInfoOffLineController();
  final HiveController _hiveController = HiveController();

  /// ========== PROCESS DATA ===============
  Future<List<LibraryModel>?> processLibraryData(
      List<LibraryModel> data) async {
    try {
      final List<MangaInfoOffLineModel>? models =
          await _hiveController.getBooks();
      if (models == null) {
        throw Exception(
            "models é nulo(algo deu errado na contrução dos models) em HiveController.getBooks");
      }
      ClientDataModel clientData = await _hiveController.getClientData();
      for (int modelIndex = 0; modelIndex < data.length; modelIndex++) {
        for (int bookIndex = 0;
            bookIndex < data[modelIndex].books.length;
            bookIndex++) {
          MangaInfoOffLineModel? modelData = await compute(getModelFromData, [
            data[modelIndex].books[bookIndex].link,
            data[modelIndex].books[bookIndex].idExtension,
            models
          ]);
          final Books bookData = await compute(processOneModel,
              [data[modelIndex].books[bookIndex], modelData!, clientData]);
          data[modelIndex].books[bookIndex] = bookData;
        }
      }
      return data;
    } catch (e) {
      debugPrint(
          "erro no processLibraryData at library/controllers/library_controller.dart: $e");
      MessageCore.showMessage(e.toString());
      return null;
    }
  }

  /// =============== PROCESS ONE BOOK ==================
  static Future<Books> processOneModel(List<dynamic> objects) async {
    Books model = objects[0];
    MangaInfoOffLineModel data = objects[1];
    ClientDataModel clientData = objects[2];
    // achar os capitulos lidos do manga pelo link
    List<dynamic> capitulosLidos = [];
    String completUrl = model.link.contains("http")
        ? model.link
        : mapOfExtensions[model.idExtension]!.getLink(model.link);
    RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);

    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        /// modify restantChapters
        model.restantChapters = data.chapters - capitulosLidos.length;
        break;
      }
    }

    /// modify name
    model.name = data.name;
    return model;
  }

  static MangaInfoOffLineModel? getModelFromData(List<dynamic> objects) {
    String link = objects[0];
    final int idExtension = objects[1];
    final List<MangaInfoOffLineModel> lista = objects[2];
    if (!link.contains("/")) {
      link = mapOfExtensions[idExtension]!.getLink(link);
    }
    RegExp regex = RegExp(link, caseSensitive: false);
    for (int i = 0; i < lista.length; ++i) {
      if ((lista[i].link.contains(regex)) &&
          (lista[i].idExtension == idExtension)) {
        debugPrint("achado na memória!");
        return lista[i];
      }
    }
    debugPrint("não encontrei o manga na memoria");
    return null;
  }
}
