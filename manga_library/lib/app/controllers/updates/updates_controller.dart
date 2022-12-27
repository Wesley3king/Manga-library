import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:dart_date/dart_date.dart';

class UpdatesCore {
  static bool isUpdating = false;

  static void verifyIfIsTimeToUpdate() async {
    HiveController hiveController = HiveController();
    if (GlobalData.settings.update != "0") {
      /*
      {"option": "Nunca", "value": "0"},
      {"option": "A cada 6 Horas", "value": "6"},
      {"option": "A cada 12 Horas", "value": "12"},
      {"option": "Uma vez no Dia", "value": "24"},
      {"option": "Uma vez na Semana", "value": "1"}
      */

      ClientDataModel clientData = await hiveController.getClientData();
      // now
      final DateTime nowTime = DateTime.now();
      // last
      final DateTime lastUpdateTime =
          DateTime.parse(clientData.lastUpdate);

      /// A cada 6 Horas
      bool verify6() => (nowTime - const Duration(hours: 6)) >= lastUpdateTime;

      /// A cada 12 Horas
      bool verify12() =>
          (nowTime - const Duration(hours: 12)) >= lastUpdateTime;

      /// Uma vez ao dia
      bool verify24() => (nowTime - const Duration(days: 1)) >= lastUpdateTime;

      /// uma vez por semana
      bool verifyOneTimeOnWeek() =>
          (nowTime - const Duration(days: 7)) >= lastUpdateTime;

      /// vericar o intervalo de atualização
      switch (GlobalData.settings.update) {
        case "6":
          if (verify6()) {
            start();
          }
          break;
        case "12":
          if (verify12()) {
            start();
          }
          break;
        case "24":
          if (verify24()) {
            start();
          }
          break;
        case "1":
          if (verifyOneTimeOnWeek()) {
            start();
          }
          break;
      }
      clientData.lastUpdate = '$nowTime';
      await hiveController.updateClientData(clientData);
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
          bool response = await updateAnBook(models[model].books[bookIndice]);
          //compute(updateAnBook, models[model].books[bookIndice]);
          //debugPrint("resposta do update: $response");
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
    debugPrint("=========== ATUALIZANDO [ ${book.name} ] ==========");
    try {
      final bool data = await controller.updateBook(book.link, book.idExtension,
          isAnUpdateFromCore: true);
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
