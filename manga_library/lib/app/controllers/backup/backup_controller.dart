import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/models/libraries_model.dart';

import '../../models/manga_info_offline_model.dart';

/// controla a criação de backups
class BackupCore {
  /// cria um backup
  static void createBackup() async {
    final HiveController hiveController = HiveController();
    final FileManager fileManager = FileManager();

    try {
      // client data
      var clientData = await hiveController.getClientData();
      if (clientData is ClientDataModel) {
        clientData = clientData.toJson();
      } else {
        log("não é clientdata model: ${clientData.runtimeType}");
      }
      // libraries
      var librariesData = await hiveController.getLibraries();
      var libraries = librariesData.map((model) => model.toJson()).toList();

      // ocultlibraries ocultLibraries
      var ocultLibrariesData = await hiveController.getOcultLibraries();
      var ocultLibraries =
          ocultLibrariesData.map((model) => model.toJson()).toList();

      // historic
      List<HistoricModel> historicModels = await hiveController.getHistoric();
      List<dynamic> historicData =
          historicModels.map((HistoricModel model) => model.toJson()).toList();
      // home page
      List<ModelHomePage>? homePageModels = await hiveController.getHomePage();
      List<dynamic>? homePageData =
          homePageModels?.map((ModelHomePage model) => model.toJson()).toList();

      // settings
      Map<dynamic, dynamic> settings = await hiveController.getSettings();

      // books
      List<MangaInfoOffLineModel>? booksData = await hiveController.getBooks();
      List<dynamic> books = booksData == null
          ? []
          : booksData
              .map((MangaInfoOffLineModel model) => model.toJson())
              .toList();

      Map<String, dynamic> backupData = {
        "clientData": clientData,
        "homePage": homePageData,
        "libraries": libraries,
        "ocultLibraries": ocultLibraries,
        "historic": historicData,
        "settings": settings,
        "books": books
      };

      // path date = D-M-Y _ H-M-S
      String path =
          "/storage/emulated/0/Manga Library/Backups/Backup_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.gz";
      await fileManager.createGzFile(backupData: backupData, path: path);
    } catch (e) {
      debugPrint("erro no createBackup at BackupCore: $e");
    }
  }

  static Future<String> readBackup() async {
    final HiveController hiveController = HiveController();
    final FileManager fileManager = FileManager();
    String message = "";
    try {
      //message += "0, ";
      final dynamic data = await fileManager.getAnGZFile();
      if (data == null) {
        message += "isNULL";
      }
      //message += "$data";
      // ============ clientData ====================
      var dados = data['clientData'];
      var model = ClientDataModel.fromJson(dados);

      await hiveController.updateClientData(model);

      // =========== home page ====================
      List<ModelHomePage>? homePageData = data['homePage']
          ?.map<ModelHomePage>((dynamic json) => ModelHomePage.fromJson(json))
          .toList();

      await hiveController.updateHomePage(homePageData ?? []);

      // ================ libraries ====================- updateLibraries(List<LibraryModel> listModel)
      List<LibraryModel> libraryList = data['libraries']
          .map<LibraryModel>((dynamic json) => LibraryModel.fromJson(json))
          .toList(); // Map<String, >
      await hiveController.updateLibraries(libraryList);
      // ================ ocult libraries =================================
      List<LibraryModel> ocultLibraryList = data['ocultLibraries']
          .map<LibraryModel>((dynamic json) => LibraryModel.fromJson(json))
          .toList();
      await hiveController.updateOcultLibraries(ocultLibraryList);
      // ================= settings =============================
      await hiveController.updateSettings(data['settings']);
      // ================ historic ==============================
      List<HistoricModel> historicModels = data['historic']
          .map<HistoricModel>((dynamic json) => HistoricModel.fromJson(json))
          .toList();
      await hiveController.updateHistoric(historicModels);
      //message += "4, ";
      // ======================= books ====================
      var books = data['books']
          .map<MangaInfoOffLineModel>(
              (dynamic book) => MangaInfoOffLineModel.fromJson(book))
          .toList();

      await hiveController.updateBook(books);

      return "sucess";
    } catch (e) {
      debugPrint("erro no readBackup at BackupCore: $e");
      return '$message - $e';
    }
  }
}
