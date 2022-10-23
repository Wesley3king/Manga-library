import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class UpdatesCore {
  static bool isUpdating = false;

  static void verifyIfIsTimeToUpdate() async {
    if (true) {
      /// implemet teste
    }
  }

  static void start() async {
    if (isUpdating == false) {
      final HiveController hiveController = HiveController();
      List<LibraryModel> models = await hiveController.getLibraries();
      updateMachine(models, hiveController);
    }
  }

  static void updateMachine(
      List<LibraryModel> models, HiveController hiveController) async {
    List<Map<String, dynamic>> alreadyUpdated = [];
    isUpdating = true;

    for (int model = 0; model < models.length; ++model) {
      /// fazer a busca de livros
      for (int bookIndice = 0;
          bookIndice < models[model].books.length;
          ++bookIndice) {
        bool isUpdated = false;
        for (Map<String, dynamic> map in alreadyUpdated) {
          if (map['link'] == models[model].books[bookIndice].link &&
              map['idExtension'] ==
                  models[model].books[bookIndice].idExtension) {
            isUpdated = true;
          }
        }

        if (!isUpdated) {
          /// implement update
          bool response =
              await compute(updateAnBook, models[model].books[bookIndice]);
          debugPrint("resposta do update: $response");
          if (response) {
            alreadyUpdated.add({
              "link": models[model].books[bookIndice].link,
              "idExtension": models[model].books[bookIndice].idExtension
            });
          }
        }
      }
    }
    isUpdating = false;
  }

  /// atualiza o livro
  static Future<bool> updateAnBook(Books book) async {
    MangaInfoController controller = MangaInfoController();
    try {
      final bool data =
          await controller.updateBook(book.link, book.idExtension);

      if (data) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("erro no updateAnBook at UpdatesCore: $e");
      return false;
    }
  }
}
