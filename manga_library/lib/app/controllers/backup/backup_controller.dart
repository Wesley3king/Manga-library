import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/client_data_model.dart';
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
        "libraries": libraries,
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
      // clientData
      var dados = data['clientData'];
      //message += "1.1, ";
      var model = ClientDataModel.fromJson(dados);
      //message += "1.2, ";
      await hiveController.updateClientData(model);
      //message += "2, ";
      // libraries - updateLibraries(List<LibraryModel> listModel)
      List<LibraryModel> libraryList = data['libraries']
          .map<LibraryModel>((dynamic json) => LibraryModel.fromJson(json))
          .toList(); // Map<String, >
      await hiveController.updateLibraries(libraryList);
      //message += "3, ";
      // settings
      await hiveController.updateSettings(data['settings']);
      //message += "4, ";
      // books - List<MangaInfoOffLineModel> data
      var books = data['books']
          .map<MangaInfoOffLineModel>(
              (dynamic book) => MangaInfoOffLineModel.fromJson(book))
          .toList();
      //message += "4.5, ";
      await hiveController.updateBook(books);
      // message += "5, ";
      return "sucess";
    } catch (e) {
      debugPrint("erro no readBackup at BackupCore: $e");
      return '$message - $e';
    }
  }
}
