import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';

import '../../../models/manga_info_offline_model.dart';

List<double> getSizeOfBooks() {
  String type = GlobalData.settings.frameSize;
  // [X, Y]
  switch (type) {
    case "small":
      return [200.0, 245.0];
    case "normal":
      return [200.0, 260.0];
    case "big":
      return [210.0, 280.0];
    default:
      return [200.0, 260.0];
  }
}
/// responsavel por adiministrar a montagem dos models das libraries
class ProcessDataFromLibrary {
  /// ========== PROCESS DATA ===============
  static Future<List<LibraryModel>?> processLibraryData(
      List<dynamic> objects) async {
    final List<LibraryModel> data = objects[0];
    final List<MangaInfoOffLineModel> models = objects[1];
    final ClientDataModel clientData = objects[2];
    try {
      for (int modelIndex = 0; modelIndex < data.length; modelIndex++) {
        for (int bookIndex = 0;
            bookIndex < data[modelIndex].books.length;
            bookIndex++) {
          MangaInfoOffLineModel? modelData = getModelFromData(
              link: data[modelIndex].books[bookIndex].link,
              idExtension: data[modelIndex].books[bookIndex].idExtension,
              lista: models);
          final Books bookData = processOneModel(
              model: data[modelIndex].books[bookIndex],
              data: modelData!,
              clientData: clientData);
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
  static Books processOneModel(
      {required Books model,
      required MangaInfoOffLineModel data,
      required ClientDataModel clientData}) {
    // achar os capitulos lidos do manga pelo link
    String completUrl = model.link.contains("http")
        ? model.link
        : mapOfExtensions[model.idExtension]!.getLink(model.link);
    RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);
    bool isFound = false;

    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        model.restantChapters = data.chapters -
            List.from(clientData.capitulosLidos[i]['capitulos']).length;
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      model.restantChapters = data.chapters;
    }

    /// modify name and image
    model.name = data.name;
    model.img = data.img;
    return model;
  }

  static MangaInfoOffLineModel? getModelFromData(
      {required String link,
      required int idExtension,
      required List<MangaInfoOffLineModel> lista}) {
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
    debugPrint("não encontrei o manga na memoria: $link / id: $idExtension");
    return null;
  }
}