import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/controllers/notifications/notification_service.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/image_saver/lib/image_saver.dart';

import '../../views/manga_info/off_line/controller/off_line_widget_controller.dart';
import '../manga_info_controller.dart';

class DownloadController {
  static List<DownloadModel> filaDeDownload = [];
  static MangaInfoController? mangaInfoController;
  static bool isDownloading = false;
  static int notificationId = 1;

  static addDownload(DownloadModel model) {
    filaDeDownload.add(model);
    // caso o gerenciador de downloads não estiver ligado
    if (!isDownloading) downloadMachine();
  }

  /// Start canceling Download. It changes DownloadModel's cancel value, which causes the Download to be cancelled.
  static cancelDownload(Capitulos capitulo, String link) {
    try {
      for (int i = 0; i < filaDeDownload.length; ++i) {
        if ((filaDeDownload[i].capitulo.id == capitulo.id) &&
            (filaDeDownload[i].model.link == link)) {
          filaDeDownload[i].cancel = true;
        }
      }
    } catch (e) {
      debugPrint("erro no cancelDownload at DownloadController: $e");
    }
  }

  /// Removes images that have already been downloaded
  static deleteDownloadForCancel(String path) async {
    FileManager fileManager = FileManager();
    debugPrint("path - deleteDownload at DownloadController: $path");
    await fileManager.deleteDownloads(path);
  }

  // este gerencia todos os downloads
  static void downloadMachine() async {
    isDownloading = true;
    final DownloadController downloadController = DownloadController();

    try {
      final DownloadModel model = filaDeDownload[0];
      for (int attempts = 1; attempts < 4; ++attempts) {
        bool result = await downloadController.processOneChapter(
          capitulo: model.capitulo,
          pieceOfLink: model.pieceOfLink,
          index: 0,
          model: model.model,
        );
        // caso o download tenha sido concluido
        if (result) break;

        /// caso todas as tentativas falhe
        if (attempts == 3 && !result) {
          MessageCore.showMessage("Falha no Download de ${model.model.name}");
        }
      }
      // remove este DownloadModel
      filaDeDownload.removeAt(0);

      // for (Map<String, dynamic> removeData in dataToRemove) {
      //   filaDeDownload.removeWhere((DownloadModel downloadModel) =>
      //       downloadModel.capitulo.id == removeData["idChapter"] &&
      //       downloadModel.model.idExtension == removeData["idExtension"] &&
      //       downloadModel.model.link == removeData["link"]);
      //   //model.state?.value = DownloadStates.delete;
      // }

      // caso ainda tenha downloads
      filaDeDownload.isNotEmpty ? downloadMachine() : isDownloading = false;
    } catch (e) {
      debugPrint("erro fatal no downloadMachine at DownloadController: $e");
      isDownloading = false;
    }
  }

  Future<bool> processOneChapter({
    required Capitulos capitulo,
    required String pieceOfLink,
    required MangaInfoOffLineModel model,
    required int index,
  }) async {
    final HiveController hiveController = HiveController();
    try {
      /// verifica se este capítulo é de uma novel
      if (capitulo.pages[0].contains("== NOVEL READER ==")) {
        return await downloadNovel(
            capitulo: capitulo,
            link: model.link,
            pieceOfLink: pieceOfLink,
            name: model.name,
            img: model.img,
            idExtension: model.idExtension,
            index: index,
            hiveController: hiveController);
      }

      /// pega todos os downloads
      List<DownloadPagesModel> downloadModels =
          await hiveController.getDownloads();
      // start the download
      List<String>? downloadedPagesPath = await download(
        capitulo: capitulo,
        link: model.link,
        name: model.name,
        idExtension: model.idExtension,
        index: index,
      );
      // caso seja null deu um erro!
      if (downloadedPagesPath == null) {
        filaDeDownload[index].state?.value = DownloadStates.error;
        return false;
      }
      // caso seja um cancelamento
      if (downloadedPagesPath.isEmpty) {
        filaDeDownload[index].state?.value = DownloadStates.download;
        return true;
      }

      /// adiciona o download a memória
      downloadModels.add(DownloadPagesModel(
          id: capitulo.id,
          chapter: capitulo.capitulo,
          idExtension: model.idExtension,
          link: pieceOfLink,
          img: model.img,
          name: model.name,
          pages: downloadedPagesPath));

      /// save in database
      bool isSaved = await hiveController.updateDownloads(downloadModels);
      if (!isSaved) {
        deleteDownloadForCancel(downloadedPagesPath[0]);
        return false;
      } else {
        mangaInfoController?.updateChaptersAfterDownload(
            model.link, model.idExtension);
      }
      filaDeDownload[index].state?.value = DownloadStates.delete;
      return true;
    } catch (e) {
      debugPrint("erro no processOneChapter at DownloadController: $e");
      return false;
    }
  }

  Future<List<String>?> download({
    required Capitulos capitulo,
    required String link,
    required String name,
    required int idExtension,
    required int index,
  }) async {
    final ImageSaver imageSaver = ImageSaver();

    /// starts download notifications service
    final DownloadNotification notificationService = DownloadNotification(
        id: notificationId,
        bookAndChapter: "$name - ${capitulo.capitulo}",
        maxPages: capitulo.pages.length,
        currentPage: 0);
    notificationId++;
    try {
      // constroi o sub caminho das paginas baixadas
      List<Pattern> listOfRegExp = [
        RegExp(r'/', caseSensitive: false, dotAll: true),
        RegExp(r'~', caseSensitive: false, dotAll: true),
        ":",
        ";",
        "|",
        "\"",
        "<",
        ">",
        '"',
        "?",
        "*",
        "\n"
      ];
      String chapterPath = name.trim();
      for (Pattern regex in listOfRegExp) {
        chapterPath = chapterPath.replaceAll(regex, "_");
      }

      // caminhos das paginas
      List<String> pagesPath = [];

      // inicia os downloads de capitulo
      debugPrint("quantidade de paginas : ${capitulo.pages.length}");
      for (int i = 0; i < capitulo.pages.length; ++i) {
        // build exe
        List<String> exe = capitulo.pages[i].split(".");
        exe = exe.reversed.toList(); // file type na posição 0

        // get extesion name
        String extensionaName = mapOfExtensions[idExtension]!.nome;

        /// define o path para o armazenamento
        String storagePath = "";

        ///[ deve-se modicar ao buildar com outro id ] com.king.manga_library com.example.manga_library
        switch (GlobalData.settings.storageLocation) {
          case "intern":
            storagePath =
                "/storage/emulated/0/Android/data/com.example.manga_library/files/Downloads/$extensionaName/$chapterPath/cap_${capitulo.capitulo}/$i.${exe[0]}";
            break;
          case "extern":
            storagePath =
                "/storage/emulated/0/Manga Library/Downloads/$extensionaName/$chapterPath/cap_${capitulo.capitulo}/$i.${exe[0]}";
            break;
          case "externocult":
            storagePath =
                "/storage/emulated/0/Manga Library/Downloads/$extensionaName/.$chapterPath/cap_${capitulo.capitulo}/$i.${exe[0]}";
            break;
        }

        // cancel download
        if (filaDeDownload[index].cancel) {
          log("Cancelando o download!!!");
          // filaDeDownload[index].attempts = 3;
          notificationService.removeNotification();
          await deleteDownloadForCancel(
              pagesPath.isEmpty ? storagePath : pagesPath[0]);
          return [];
        }

        ImageSaverDownloadModel imageSaverModel = ImageSaverDownloadModel(
          savePath: storagePath,
          urlPath: capitulo.pages[i],
          options:
              Options(headers: mapOfExtensions[idExtension]!.fetchImagesHeader),
        );
        bool response = await imageSaver.download(imageSaverModel);

        if (!response) {
          notificationService.setThisAnError();
          return null;
        }
        pagesPath.add(storagePath);
        Map<String, int?> progressData = {
          "total": capitulo.pages.length,
          "progress": i
        };
        filaDeDownload[index].valueNotifier?.value = progressData;
        notificationService.updateProgress = i + 1;
      }

      return pagesPath;
    } catch (e) {
      debugPrint("erro fatal no download!: $e");
      notificationService.setThisAnError();
      return null;
    }
  }

  /// baixa uma novel
  Future<bool> downloadNovel(
      {required Capitulos capitulo,
      required String link,
      required String pieceOfLink,
      required String img,
      required String name,
      required int idExtension,
      required int index,
      required HiveController hiveController}) async {
    /// pega todos os downloads
    List<DownloadPagesModel> downloadModels =
        await hiveController.getDownloads();

    /// adiciona o download a memória
    downloadModels.add(DownloadPagesModel(
        id: capitulo.id,
        chapter: capitulo.capitulo,
        idExtension: idExtension,
        link: pieceOfLink,
        img: img,
        name: name,
        pages: capitulo.pages));

    /// save in database
    bool isSaved = await hiveController.updateDownloads(downloadModels);
    if (!isSaved) return false;

    mangaInfoController?.updateChaptersAfterDownload(link, idExtension);
    log("capitulo ${capitulo.capitulo} baixado com sucesso!!!");
    return true;
  }
}
