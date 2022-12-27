import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class UpdatesCore {
  static bool isUpdating = false;

  static void verifyIfIsTimeToUpdate() async {
    HiveController hiveController = HiveController();
    if (true) { // GlobalData.settings.update != "0"
      /*
      {"option": "Nunca", "value": "0"},
      {"option": "A cada 6 Horas", "value": "6"},
      {"option": "A cada 12 Horas", "value": "12"},
      {"option": "Uma vez no Dia", "value": "24"},
      {"option": "Uma vez na Semana", "value": "1"}
      */

      //ClientDataModel clientData = await hiveController.getClientData();

      /// get time
      String getDateTime() => '${DateTime.now()}';

      List<List<String>> processDate(String date) {
        List<String> splitedDate = date.split('.');
        List<String> dateAndHours = splitedDate[0].split(" ");

        /// hours
        List<String> hours = dateAndHours[1].split(":");

        /// date
        List<String> dates = dateAndHours[0].split("-");
        return [hours, dates];
      }

      // now
      List<List<String>> dateNow = processDate("2022-12-31 23:56:43"); // getDateTime()
      // last    2022-12-27 11:56:43
      List<List<String>> dateLastUpdate = processDate("2023-01-01 5:56:43"); // clientData.lastUpdate

      /// A cada 6 Horas
      bool verify6() {
        if ((int.parse(dateNow[0][0]) - int.parse(dateLastUpdate[0][0])) >= 6) {
          return true;
        } else if ((int.parse(dateNow[0][0]) +
                (24 - int.parse(dateLastUpdate[0][0]))) >=
            6 && dateNow[1][2] != dateLastUpdate[1][2]) {
          return true;
        }
        debugPrint("Não é hora de ATUALIZAR!");
        return false;
      }

      /// A cada 12 Horas
      bool verify12() {
        if ((int.parse(dateNow[0][0]) - int.parse(dateLastUpdate[0][0])) >=
            12) {
          return true;
        } else if ((int.parse(dateNow[0][0]) +
                (24 - int.parse(dateLastUpdate[0][0]))) >=
            12) {
          return true;
        }
        return false;
      }

      /// Uma vez ao dia
      bool verify24() {
        if (int.parse(dateNow[1][2]) >= (int.parse(dateLastUpdate[1][2]) + 1)) {
          return true;
        } else if ((int.parse(dateNow[1][2]) +
                (30 - int.parse(dateLastUpdate[1][2]))) >=
            1) {
          return true;
        }
        return false;
      }

      /// uma vez por semana
      bool verifyOneTimeOnWeek() {
        if (int.parse(dateNow[1][2]) - int.parse(dateLastUpdate[1][2]) >= 7) {
          return true;
        } else if ((int.parse(dateNow[1][2]) +
                (30 - int.parse(dateLastUpdate[1][2]))) >=
            7) {
          return true;
        }
        return false;
      }

      /// vericar o intervalo de atualização
      /// GlobalData.settings.update
      switch ("6") {
        case "6":
          final response = verify6();
          if (response) {
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
     // clientData.lastUpdate = getDateTime();
     // await hiveController.updateClientData(clientData);
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
